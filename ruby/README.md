# isomorfeus-react

Develop React components for Opal Ruby along with very easy to use and advanced React-Redux Components.

## Community and Support
At the [Isomorfeus Framework Project](http://isomorfeus.com) 

## Versioning and Compatibility
isomorfeus-react version follows the React version which features and API it implements.

### React
Isomorfeus-react 16.12.x implements features and the API of React 16.12 and should be used with React 16.12

### Preact
isomorfeus-react works with preact version 10.1.x.

### Nerv
isomorfeus-react works in general with nervjs 1.5.x. with some issues:
 - Server Side Rendering does currently not work at all.
 - Some specs with respect to callbacks (component_will_unmount) and styles fail.

## Documentation

- [Installation](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/installation.md)

Because isomorfeus-react follows closely the React principles/implementation/API and Documentation, most things of the official React documentation
apply, but in the Ruby way, see:
- https://reactjs.org/docs/getting-started.html

Component Types:
- [Class Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/class_component.md)
- [Function and Memo Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/function_component.md)
- [Lucid App, Lucid Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lucid_component.md)
- [LucidMaterial App, LucidMaterial Component](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lucid_material_component.md) - support for [MaterialUI](https://material-ui.com)
- [Lucid Func, LucidMaterial Func (for use with Hooks)](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lucid_func_component.md)
- [React Javascript Components and React Elements](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/javascript_component.md)

Which component to use?
- Usually LucidApp and LucidComponent along with some imported javascript components.
- For MaterialUI LucidMaterial::App and LucidMaterial::Component along with some imported javascript components.

Specific to Class, Lucid and LucidMaterial Components:
- [Events](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/events.md)
- [Lifecycle Callbacks](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/lifecycle_callbacks.md)
- [Props](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/props.md)
- [State](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/state.md)

For all Components:
- [Accessibility](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/accessibility.md)
- [Render Blocks](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/render_blocks.md)
- [Rendering HTML or SVG Elements](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/rendering_elements.md)

Special React Features:
- [Context](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/context.md)
- [Fragments](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/fragments.md)
- [Portals](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/portals.md)
- [Refs](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/refs.md)
- [StrictMode](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/strict_mode.md)

Other Features:
- [Code Splitting and Lazy Loading](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/code_splitting_lazy_loading.md)
- [Hot Module Reloading](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/hot_module_relaoding.md)
- [Server Side Rendering](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/server_side_rendering.md)
- [Using React Router](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/react_router.md)
- [Isomorfeus Helpers](https://github.com/isomorfeus/isomorfeus-react/blob/master/ruby/docs/isomorfeus_helpers.md)

### Development Tools
The React Developer Tools allow for analyzing, debugging and profiling components. A very helpful toolset and working very nice with isomorfeus-react:
https://github.com/facebook/react-devtools

### Specs and Benchmarks
- clone repo
- `bundle install`
- `rake`
