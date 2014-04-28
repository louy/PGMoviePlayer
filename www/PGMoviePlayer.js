var exec = require('cordova/exec');
var channel = require('cordova/channel');
var modulemapper = require('cordova/modulemapper');

function PGMoviePlayer() {
   this.channels = {
        'start' : channel.create('start'),
        'stop'  : channel.create('stop'),
        'error' : channel.create('error'),
   };
}

PGMoviePlayer.prototype = {
    init: function() {
        var self = this;
        var cb = function(eventname) {
           self._eventHandler(eventname);
        };
        exec(cb, cb, "PGMoviePlayer", "init", []);
    },

    _eventHandler: function (event) {
        if (event.type in this.channels) {
            this.channels[event.type].fire(event);
        }
    },

    play: function(OctoLink, success, fail) {
        exec(success, fail, "PGMoviePlayer", "play", [OctoLink]);
        return this;
    },

    stop: function (success, fail) {
        exec(success, fail, "PGMoviePlayer", "stop", []);
    },

    addEventListener: function (eventname,f) {
        if (eventname in this.channels) {
            this.channels[eventname].subscribe(f);
        }
    },
    removeEventListener: function(eventname, f) {
        if (eventname in this.channels) {
            this.channels[eventname].unsubscribe(f);
        }
    },
};

module.exports = new PGMoviePlayer();
