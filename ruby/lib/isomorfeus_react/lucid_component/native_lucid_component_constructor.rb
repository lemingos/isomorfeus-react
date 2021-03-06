module LucidComponent
  module NativeLucidComponentConstructor
    # for should_component_update we apply ruby semantics for comparing props
    # to do so, we convert the props to ruby hashes and then compare
    # this makes sure, that for example rubys Nil object gets handled properly
    def self.extended(base)
      component_name = base.to_s
      # language=JS
      %x{
        base.lucid_react_component = class extends Opal.global.React.Component {
          constructor(props) {
            super(props);
            const oper = Opal.React;
            if (base.$default_state_defined()) {
              this.state = base.$state().$to_n();
            } else {
              this.state = {};
            };
            this.__ruby_instance = base.$new(this);
            this.__object_id = this.__ruby_instance.$object_id().$to_s();
            if (!this.state.component_state) {
              this.state.component_state = {};
              this.state.component_state[this.__object_id] = {};
            };
            var defined_refs = #{base.defined_refs};
            for (var ref in defined_refs) {
              if (defined_refs[ref] != null) {
                this[ref] = function(element) {
                  element = oper.native_element_or_component_to_ruby(element);
                  #{`this.__ruby_instance`.instance_exec(`element`, &`defined_refs[ref]`)}
                }
                this[ref] = this[ref].bind(this);
              } else {
                this[ref] = Opal.global.React.createRef();
              }
            }
            if (base.preload_block) {
              oper.active_redux_components.push(this);
              this.state.preloaded = this.__ruby_instance.$execute_preload_block();
              oper.active_redux_components.pop();
            }
          }
          static get displayName() {
            return #{component_name};
          }
          static set displayName(new_name) {
            // dont do anything here except returning the set value
            return new_name;
          }
          render() {
            const oper = Opal.React;
            oper.render_buffer.push([]);
            // console.log("lucid component pushed", oper.render_buffer, oper.render_buffer.toString());
            oper.active_components.push(this);
            oper.active_redux_components.push(this);
            let block_result;
            if (base.while_loading_block && !this.state.preloaded) { block_result = #{`this.__ruby_instance`.instance_exec(&`base.while_loading_block`)}; }
            else { block_result = #{`this.__ruby_instance`.instance_exec(&`base.render_block`)}; }
            if (block_result && (block_result.constructor === String || block_result.constructor === Number)) { oper.render_buffer[oper.render_buffer.length - 1].push(block_result); }
            oper.active_redux_components.pop();
            oper.active_components.pop();
            // console.log("lucid component popping", oper.render_buffer, oper.render_buffer.toString());
            let result = oper.render_buffer.pop();
            if (result.length === 1) { return result[0]; }
            return result;
          }
          data_access() {
            return this.props.store;
          }
          shouldComponentUpdate(next_props, next_state) {
            let counter = 0;
            for (var property in next_props) {
              counter++;
              if (next_props.hasOwnProperty(property)) {
                if (!this.props.hasOwnProperty(property)) { return true; };
                if (property === "children") { if (next_props.children !== this.props.children) { return true; }}
                else if (typeof next_props[property] !== "undefined" && next_props[property] !== null && typeof next_props[property]['$!='] === "function" &&
                         typeof this.props[property] !== "undefined" && this.props[property] !== null ) {
                  if (#{ !! (`next_props[property]` != `this.props[property]`) }) { return true; }
                } else if (next_props[property] !== this.props[property]) { return true; }
              }
            }
            if (counter !== Object.keys(this.props).length) { return true; }
            counter = 0;
            for (var property in next_state) {
              counter++;
              if (next_state.hasOwnProperty(property)) {
                if (!this.state.hasOwnProperty(property)) { return true; };
                if (typeof next_state[property] !== "undefined" && next_state[property] !== null && typeof next_state[property]['$!='] === "function" &&
                    typeof this.state[property] !== "undefined" && this.state[property] !== null) {
                  if (#{ !! (`next_state[property]` != `this.state[property]`) }) { return true }
                } else if (next_state[property] !== this.state[property]) { return true }
              }
            }
            if (counter !== Object.keys(this.state).length) { return true; }
            return false;
          }
          validateProp(props, propName, componentName) {
            try { base.$validate_prop(propName, props[propName]) }
            catch (e) { return new Error(componentName + " Error: prop validation failed: " + e.message); }
            return null;
          }
        };
        base.preload_block = null;
        base.while_loading_block = null;
        base.jss_styles = null;
        base.use_styles = null;
        base.store_updates = true;
      }
    end
  end
end
