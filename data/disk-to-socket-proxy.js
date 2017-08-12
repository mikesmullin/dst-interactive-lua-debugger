"use strict";

let connectionEstablished = false;

const READ_FILE = 'C:\\Program Files (x86)\\Steam\\steamapps\\common\\Don\'t Starve Together Beta\\data\\debug_read';
const WRITE_FILE = 'C:\\Program Files (x86)\\Steam\\steamapps\\common\\Don\'t Starve Together Beta\\data\\debug_write';
const LOG_FILE = 'disk-to-socket-proxy.log'
const fs = require('fs');

const _log = fs.openSync(LOG_FILE, 'w');
fs.fsyncSync(_log);
const log = (s) => fs.writeSync(_log, s +"\n");


process.on('uncaughtException', function(err) {
	console.log('uncaught err', err);
});

function resetFile(f) {
	let tmp = fs.openSync(f, 'w');
	fs.closeSync(tmp);
}
resetFile(READ_FILE);
resetFile(WRITE_FILE);

// from IDE-runtime to node process
const out = fs.openSync(READ_FILE, 'w');
fs.fsyncSync(out);

const net = require('net');
const socket = new net.Socket();
socket.setNoDelay(true);
socket.on("connect", function() {
	log("connected");
	connectionEstablished = true;

	// from IDE-runtime to node process
	let queue = [];
	let isWatching = false;
	let watcher = null;
	let pos = 0;
	let filename = WRITE_FILE;

	let stream;
	function readBlock() {
		if (null != stream) { stream.close(); }
		if (queue.length >= 1) {
			let block = queue.shift();
			if (block.end > block.start) {
				stream = fs.createReadStream(filename, { start: block.start, end: block.end - 1, encoding: 'utf-8'});
				stream.on('error', (error) => log('error '+ JSON.stringify(error)));
				stream.on('end', () => { if (queue.length >= 1) readBlock(); });
				stream.on('data', (chunk) => {
					// from node process to cpp process
					log('runtime->IDE '+ chunk.toString());
					socket.write(chunk);
				});
			}
		}
	}

	function watch() {
		if (isWatching) return;
		isWatching = true;
		let stats = fs.statSync(filename);
		pos = stats.size;

		watcher = fs.watch(filename, {}, (e) => {
			JSON.stringify(('e:', e));
			let stats = fs.statSync(filename);
			JSON.stringify(('stats:', stats));
			if (e == 'change') {
				//scenario where texts is not appended but it's actually a w+
				if (stats.size < pos) pos = stats.size;
				if (stats.size > pos) {
					queue.push({start: pos, end: stats.size});
					pos = stats.size;
					if (queue.length == 1) readBlock();
				}
			}
			else if (e == 'rename') {
				fs.unwatchFile(filename);
				isWatching = false;
				queue = [];
				setTimeout(watch, 3000);
			}
		});
	}
	watch();
});

// from cpp process to node process
socket.on('data', function(chunk) {
	log('IDE->runtime '+ chunk.toString());
	fs.writeSync(out, chunk);
});

socket.on('close', function(err) {
	log('end of session. '+ JSON.stringify(err));
	if (connectionEstablished) {
		// exit gracefully

		// close open file handles
		fs.close(out);

		// scrub logs for next time
		resetFile(READ_FILE);
		resetFile(WRITE_FILE);

		process.exit(0);
	}
});

socket.on('error', function(err) {
	console.log('err', err);
	if ('ECONNREFUSED' == err.code && !connectionEstablished) {
		setTimeout(retry, 250);
	}
});

function retry() {
	console.log('trying to connect...');
	socket.connect(56789, 'localhost');
};
retry();


process.stdin.resume();
