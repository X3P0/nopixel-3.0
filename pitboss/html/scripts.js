(function() {
    this.listener = window.addEventListener('message', function(event)
    {
        const item = event.data
        if (this[item.type]) {
            this[item.type](item)
        }
        else {
            this.noMethod(item.type);
        }
    });

    this.DISPLAY_INSTRUCTIONS = (data) => {
            $("#container").show();
    }

    this.CLOSE_INSTRUCTIONS = (data) => {
            $("#container").hide();
    }

    this.PITBOSS_MESSAGE = (data) => {
        $("#message").html(data.message);
        $("#message").show();
        setTimeout(function(){
            $("#message").hide();
            $("#message").html("");
        },5000)
    }
    this.PITBOSS_CARDS = (data) => {
        // console.log('can we show this plz?');
        if (data.close) {
            $("#cards").hide();
            return
        }
        $("#cards").html(data.message);
        $("#cards").css('background-color',data.background);
        if (data.background == 'yellow') {
            $("#cards").css('background-color',data.background);
            $("#cards").css('color','black');
        } else {
            $("#cards").css('background-color',data.background);
            $("#cards").css('color','white');
            
        }
        $("#cards").show();
    }
    this.noMethod = (type) => {
        // $.post('https://ubereats/invalidMethod',
        // JSON.stringify({message: `${type} is not a valid command`}))
        console.log('no valid method')
    }
})();

