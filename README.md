Alternator
----------

Converts traditional AMD syntax into the more compatable CommonJS form

```
define([
    'config',
    'models/base',
    'models/decorators/singleton'
], function (
    config,
    BaseModel,
    singleton
) {
    'use strict';

    var Model = BaseModel.extend({

        relations: {
            context: 'models/category'
        },

        defaults: {

            // The current Category context of the application. This has a
            // variety of effects throughout Kindling.
            context: null
        }
    });

    return singleton(Model, {
        context: config.data('context')
    });
});
```

to...

```
define(function (require) {

  var config = require('config');
  var BaseModel = require('models/base');
  var singleton = require('models/decorators/singleton');

    'use strict';

    var Model = BaseModel.extend({

        relations: {
            context: 'models/category'
        },

        defaults: {

            // The current Category context of the application. This has a
            // variety of effects throughout Kindling.
            context: null
        }
    });

    return singleton(Model, {
        context: config.data('context')
    });
});
```
