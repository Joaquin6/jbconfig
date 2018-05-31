"use strict";

module.exports = {
	reporter: function(results) {
		// Categorise each error by filename.
		var errors = results.reduce(function(previous, current) {
			if (!previous[current.file]) {
				previous[current.file] = [];
			}

            var error = current.error;

            previous[current.file].push(current.file + "(" + error.line + "," + error.character + ")" + ": " + error.reason + "(" + error.code + ")");

			return previous;
		}, {});

		if (Object.keys(errors).length > 0) {
			console.log("");

			Object.keys(errors).forEach(function(key) {
				errors[key].forEach(function(error) {
					console.log(error);
				});
			});

			console.log("");
		}
	}
};