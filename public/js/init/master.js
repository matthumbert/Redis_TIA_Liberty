 Reveal.initialize({
    controls: true,
    progress: true,
    history: true,
    center: true,

    theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
    transition: Reveal.getQueryHash().transition || 'default', // default/cube/page/concave/zoom/linear/fade/none

    multiplex: {
        // Example values. To generate your own, see the socket.io server instructions.
        id: socketConfig.id, // id, obtained from socket.io server
        secret: socketConfig.secret, // null so the clients do not have control of the master presentation
        url: socketConfig.fromMaster // Location of socket.io server
    },

    // Optional libraries used to extend on reveal.js
    dependencies: [
        { src: 'public/bower_components/reveal.js/lib/js/classList.js', condition: function() { return !document.body.classList; } },
        { src: 'public/bower_components/reveal.js/plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
        { src: 'public/bower_components/reveal.js/plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
        { src: 'public/bower_components/reveal.js/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
        { src: 'public/bower_components/reveal.js/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
        { src: 'public/bower_components/reveal.js/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } },
        { src: 'public/js/multiplex/master.js', async: true },
        //{ src: 'bower_components/reveal.js/plugin/remotes/remotes.js', async: true, condition: function() { return !!document.body.classList; } },
        { src: 'public/js/loadhtmlslides.js', condition: function() { return !!document.querySelector( '[data-html]' ); } }
        
    ]
});

(function(){

    var tendencyBar = $('.global-votes-tendency'),
        positiveBar = $('.global-votes-tendency .positive'),
        negativeBar = $('.global-votes-tendency .negative'),
        lastPosPct, lastNegPct;

    setInterval(function(){

        $.get('/api/vote/all/stats').success(function(stats){

            var posPct = stats.yes;
            var negPct = stats.no;

            console.log('Global stats -> yes:' + posPct + '%, no:' + negPct + '%');

            if(posPct || negPct){
                tendencyBar.show();
            } else {
                tendencyBar.hide();
                return;
            }

            if(posPct > lastPosPct){
                var progression = posPct - lastPosPct;
                console.log("UP tendency +" + progression + "pt.");
            } else if (posPct === negPct) { 
            } else if (negPct > lastNegPct) {
                var regression = lastNegPct - negPct;
                console.log("DOWN tendency " + regression + "pt.");
            }

            positiveBar.width(posPct + '%');
            negativeBar.width(negPct + '%');

            lastPosPct = posPct;
            lastNegPct = negPct;

        });

    }, 1000);

})();