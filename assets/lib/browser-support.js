(function (){
    function req(name, obj) {
        var valid;

        try {
            valid = obj[name];
        } catch (err) {
            valid = undefined;
        }

        if (valid === undefined && console) console.log('Missing JS feature: ' + name);
        return (valid !== undefined);
    }

    function css(prop, val) {
        var valid;

        try {
            if (val) {
                valid = CSS && CSS.supports && CSS.supports(prop, val);
            } else {
                // Support query string (instead of prop:val)
                valid = CSS && CSS.supports && CSS.supports(prop);
            }
        } catch (err) {
            valid = false;
        }

        if (!valid && console) console.log('Missing CSS feature: ' + [prop, val].join(', '));
        return valid;
    }

    function browserCheck() {
        var browserTest = true,
            valid;

        return ({% for rule in site.data.browser_support.rules %}{%
            if rule[1].req 

                %}
            /* Check {{ rule[0] }}: {{ rule[1].req[0] }} in {{ rule[1].req[1] }} */
            req('{{ rule[1].req[0] }}', {{ rule[1].req[1] }}) && {%

            elsif rule[1].css
            %}{%
                if rule[1].css[1] 

                    %}
            /* Check {{ rule[0] }}: @supports({{ rule[1].css[0] }}:{{ rule[1].css[1] }}) */
            css('{{ rule[1].css[0] }}', '{{ rule[1].css[1] }}') && {%

                else

                    %}
            /* Check {{ rule[0] }}: @supports({{ rule[1].css }}) */
            css('{{ rule[1].css }}') && {%

                endif
                %}{%
            endif
            %}{%
        endfor %}
        true);
    }

    // Success handler
    function success() {
        document
            .getElementById('browser-support')
            .setAttribute('data-browser-supported', true);
    }

    // Bind an event listener for when the page has loaded
    document.addEventListener('DOMContentLoaded', function(event) {
        document.getElementById('browser-support') &&
            browserCheck() &&
            success();
    });
}());