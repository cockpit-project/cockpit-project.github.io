---
title: Cockpit Coding Guidelines
source: https://github.com/cockpit-project/cockpit/wiki/Cockpit-Coding-Guidelines
---

## General
* No trailing whitespace, no tab characters, except in Makefile.am files
* Generally line length should be limited to 120 chars
* Indentation: 4 spaces per level, no tabs

## Languages
* [C](#cstyle)
* [JavaScript](#jsstyle)
* [CSS/HTML](#cssstyle)
* [Python](#pythonstyle)

<a name="cstyle"/>

## C style

* [Gtk+ coding standards](https://github.com/GNOME/gtk/blob/main/docs/CODING-STYLE.md)
* GNU C with C11 features is allowed and the default.
* When in doubt, check the surrounding code and try to imitate it.

* Exception: We don't require tabular alignment of function arguments like GTK and Glib do. Function definitions look like this:

```c
static JsonArray *
interframe_compress_samples (int count,
                             JsonArray *samples)
{
  /* code */
}
```

[Sample code](https://github.com/cockpit-project/cockpit/blob/30270ca580159cc4a0e0238b17f75bc7e03cbe2f/src/websocket/websocketconnection.c#L658-L671)
```c
/* Store the code/data payload */
if (len >= 2)
  {
    pv->peer_close_code = (guint16)data[0] << 8 | data[1];
  }
if (len > 2)
  {
    data += 2;
    len -= 2;
    if (g_utf8_validate ((gchar *)data, len, NULL))
      pv->peer_close_data = g_strndup ((gchar *)data, len);
    else
      g_message ("received non-UTF8 close data: %d '%.*s' %d", (int)len, (int)len, (gchar *)data, (int)data[0]);
  }
```

<a name="jsstyle"/>

## JavaScript style

* Private scopes are only necessary in code that is not bundled with webpack.
* ```"use strict"``` should be set on code that is not bundled with webpack.
* [Crockford](http://javascript.crockford.com/code.html) with lots of exceptions
* Chained calls may be placed on separate lines for readability (see example below)

Don't indent top level code, even if using a top level private scope (see above).

```javascript
(function() {
"use strict";

console.log("not indented");

}());
```

Variables should be declared outside of loops or condition braces.

```javascript
{
  var demo = 1; /* here */
  while(false) {
     /* not here */
  }
}
```

Function declarations and invocations should have no space after function name. Function starting brace goes on same line as ```function``` keyword.

```javascript
function name(arg) {
   /* body */
}
```

Anonymous functions do not need a space between the ```function``` keyword and arguments.

```javascript
div.onclick = function(e) {
   /* body */
}
```

Control flow keywords such as ```if``` ```for``` and ```while``` should have a space after them. If there is only one statement in a conditional or loop, you may leave out the braces.

```javascript
while (false)
   console.log("never reached");
```

All binary operators except . (period) and ( (left parenthesis) and [ (left bracket) should be separated from their operands by a space.

[More Sample code](https://github.com/cockpit-project/cockpit/blob/30270ca580159cc4a0e0238b17f75bc7e03cbe2f/pkg/shell/cockpit-docker.js#L588-L597)
```javascript
/* if an image is older than two days, don't show the time */
var threshold_date = new Date(image.Created * 1000);
threshold_date.setDate(threshold_date.getDate() + 2);

if (threshold_date > (new Date())) {
    $(row[1]).text(new Date(image.Created * 1000).toLocaleString());
} else {
    var creation_date = new Date(image.Created * 1000);

    /* we hide the time, so put full timestamp in the hover text */
    $(row[1])
        .text(creation_date.toLocaleDateString())
        .attr("title", creation_date.toLocaleString());
}
```

New javascript files should be in the [Asynchronous Module Definition](http://dojotoolkit.org/documentation/tutorials/1.10/modules/index.html) form. For example:

```javascript
define([
    "jquery",
    "base1/cockpit"
], function($, cockpit) {
    /* ... */

    var module = {
        api1: function api1() { /* ... */ },
        api2: function api2() { /* ... */ }
    };

    return module;
});
```

As a general rule: Modules that return API (as above) should avoid global side-effects. And modules that have global side-effects should not return or define API.

React/JSX conventions:
* Wrap multiline jsx in parentheses
* Inside JSX code, simple variables or expressions don't require spaces in curly braces, complex ones do, `{key.val}` and `{key}` but `{ this.props.fun_stuff.map(myMapFunction) }`

```jsx
var panel = (
    <tr className="listing-panel">
        <td colSpan={ header_entries.length + (expand_toggle?1:0) }>
            <div className="listing-head">
                <div className="listing-actions">
                    {this.props.listingActions}
                </div>
                <ul className="nav nav-tabs nav-tabs-pf">
                    {links}
                </ul>
            </div>
            {tabs}
        </td>
    </tr>
);
```



<a name="cssstyle"/>

## CSS/HTML style
* Use dashes instead of underscores in ids
* Use namespaces for ids if writing code that is consumed as part of a larger whole.

[Sample code](https://github.com/cockpit-project/cockpit/blob/97e0a7d7a11bc64da7f6a48ae27039f061977f6e/pkg/lib/page.scss#L99)
```css
/* Panels don't draw borders between them */
.panel > .table > tbody:first-child td {
    border-top: 1px solid rgb(221, 221, 221);
}

/* Table headers should not generate a double border */
.panel .table thead tr th {
    border-bottom: none;
}
```

<a name="pythonstyle"/>

## Python style
* [PEP 8](https://www.python.org/dev/peps/pep-0008/)

[Sample code](https://github.com/cockpit-project/cockpit/blob/badd626498dd469dae10ff13f8ad03717835ccb7/tools/tap-gtester#L97-L112)
```python
def run(self, proc, output=""):
    # Complete retrieval of the list of tests
    output += proc.stdout.read()
    proc.wait()
    if proc.returncode:
        sys.stderr.write("tap-gtester: listing GTest tests failed: %d\n" % proc.returncode)
        return proc.returncode
    self.test_remaining = []
    for line in output.split("\n"):
        if line.startswith("/"):
            self.test_remaining.append(line.strip())
    if not self.test_remaining:
        print "Bail out! No tests found in GTest: %s" % self.command[0]
        return 0

    print "1..%d" % len(self.test_remaining)
```

<a name="emacs"/>

## Emacs setup
```emacs
(setq indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq whitespace-style '(face trailing lines-tail empty))
(setq whitespace-line-column 120)
(global-whitespace-mode)
```