(function (){
    function req(name, obj) {
        var valid;

        try {
            valid = obj[name];
        } catch (err) {
            valid = undefined;
        }

        return (valid !== undefined);
    }

    function css(prop, val) {
        var valid;

        try {
            valid = CSS.supports(prop, val);
        } catch (err) {
            valid = false;
        }

        return valid;
    }

    function browserCheck() {
        var browserTest = true,
            valid;

        {% for rule in site.data.browser_support.rules %}{% if rule[1].req %}
        /* Check {{ rule[0] }}: {{ rule[1].req[0] }} in {{ rule[1].req[1] }} */
        if (!req('{{ rule[1].req[0] }}', {{ rule[1].req[1] }})) browserTest = false;
        {% endif %}{% if rule[1].css %}
        /* Check {{ rule[0] }}: @supports({{ rule[1].css[0] }}:{{ rule[1].css[1] }}) */
        if (!css('{{ rule[1].css[0] }}', '{{ rule[1].css[1] }}')) browserTest = false;
        {% endif %}{% endfor %}

        return browserTest;
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