/* global instantsearch */

export const datesRange = function(args) {
  var container = args['container'];
  var attributeName = args['attributeName'];
  var id = args['id'];

  return {
    fromInput: null,
    toInput: null,
    _refine: function (helper, from, to) {
      const facetValues = this._extractRefinedRange(helper);
      helper.clearRefinements(attributeName);
      if (facetValues.length === 0 || facetValues[0].from !== from || facetValues[0].to !== to) {
        if (typeof from !== 'undefined' && !isNaN(from)) {
          helper.addNumericRefinement(attributeName, '>=', from);
        }
        if (typeof to !== 'undefined' && !isNaN(to)) {
          helper.addNumericRefinement(attributeName, '<=', to);
        }
      }

      helper.search();
    },
    _extractRefinedRange(helper) {
      const refinements = helper.getRefinements(attributeName);
      let from;
      let to;

      if (refinements.length === 0) {
        return [];
      }

      refinements.forEach(v => {
        if (v.operator.indexOf('>') !== -1) {
          from = Math.floor(v.value[0]);
        } else if (v.operator.indexOf('<') !== -1) {
          to = Math.ceil(v.value[0]);
        }
      });

      return [{from, to, isRefined: true}];
    },
    _createComponent: function(fromValue, toValue) {
      var self = this;

      var createContainer = function(className, elements) {
        var _container = document.createElement("div");

        if (className) {
          _container.classList.add(className);
        }

        if (elements && Array.isArray(elements)) {
          elements.forEach(function(element) {
            _container.append(element);
          })
        }

        return _container;
      }

      var generateWidgetId = function(name) {
        return id + '_' + name;
      }

      var createWidgetStructure = function(label, inputElement) {
        document.querySelector(container).append(
          createContainer("form-group", [
            label, createContainer(null, [inputElement])
          ])
        );
      }

      var createInput = function(name, value, onChange) {
        var input = document.createElement('input');
        input.setAttribute("type", "date");
        input.id = generateWidgetId(name);

        if (value) {
          input.value = new Date(value).toJSON().substring(0,10);
        }

        input.onchange = onChange;

        return input;
      }

      var createLabel = function(name, text) {
        var label = document.createElement('label');
        label.setAttribute('for', generateWidgetId(name));
        label.innerHTML = text;

        return label;
      }

      var onChange = function() {
        var fromValue = new Date(self.fromInput.value).getTime();
        var toValue = new Date(self.toInput.value).getTime();

        self._refine(fromValue, toValue);
      }

      this.fromInput = createInput("from", fromValue, onChange);
      this.toInput = createInput("to", toValue, onChange);

      createWidgetStructure(createLabel("from", getTranslation("from")), this.fromInput);
      createWidgetStructure(createLabel("to", getTranslation("to")), this.toInput);

    },
    getConfiguration: function () {
      return {
        facets: [attributeName]
      }
    },
    init: function (options) {
      this._refine = this._refine.bind(this, options.helper);
    },
    render: function (options) {
      var results = options['results'];
      var helper = options['helper'];
      var state = options['state'];
      var createURL = options['createURL'];

      let facetValues = [];

      if (results.hits.length > 0) {
        facetValues = this._extractRefinedRange(helper);
      }

      var mappedValues = facetValues.map(facetValue => {
        let newState = state.clearRefinements(attributeName);
        if (!facetValue.isRefined) {
          if (facetValue.from !== undefined) {
            newState = newState.addNumericRefinement(attributeName, '>=', facetValue.from);
          }
          if (facetValue.to !== undefined) {
            newState = newState.addNumericRefinement(attributeName, '<=', facetValue.to);
          }
        }

        facetValue.url = createURL(newState);

        return facetValue;
      });

      var values = mappedValues.find(function(value) {
        return value.hasOwnProperty("from") && value.hasOwnProperty("to");
      });

      var valueFrom = null;
      var valueTo = null;

      if (values) {
        valueFrom = values["from"];
        valueTo = values["to"];
      }

      if (!this.fromInput && !this.toInput) {
        this._createComponent(valueFrom, valueTo);
      }
    }
  };
}
