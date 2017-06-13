# Elm Json Transform

[![Build Status](https://travis-ci.org/kingsleyh/elm-json-transform.svg?branch=master)](https://travis-ci.org/kingsleyh/elm-json-transform)

This project provides a way to transform a json string. It uses Native javascript under the hood. For reasons of simplicity and usability it takes the json as a string and returns the modified json as a string. This is because that is what my use case for building this library was.

It uses [js-traverse](https://github.com/substack/js-traverse) to traverse and modify JavaScript object nodes that match [JSONSelect](http://jsonselect.org/) selectors.

There are 5 things you can do given the following json string:

```json
{
   "george": {
      "age": 35,
      "movie": "Repo Man"
   },
   "mary": {
      "age": 15,
      "movie": "Twilight"
   }
}
```

### forEach

Iterates over all matching nodes in the object. The callback gets a special `this` context. See [js-traverse](https://github.com/substack/js-traverse) for all the things you can do to modify and inspect the node with this context. In addition, js-select adds a `this.matches()` which will test if the node matches a selector:

```
func = """
function(node) {
   if (this.matches(".mary > .movie")) {
      this.remove();
   }
}
"""

forEach obj func

returns:

{
   "george": {
      "age": 35,
      "movie": "Repo Man"
   },
   "mary": {
      "age": 15
   }
}
```
