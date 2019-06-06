require 'spec_helper'

RSpec.describe 'React::Component' do
  # tests are running in production mode, so we dont see all warning messages of react like in development

  context 'it can render a component that is using' do
    before do
      @doc = visit('/')
    end

    it 'inheritance' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          render do
            DIV(id: :test_component) { 'TestComponent rendered' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('TestComponent rendered')
    end

    it 'mixin' do
      @doc.evaluate_ruby do
        class TestComponent
          include React::Component::Mixin
          render do
            DIV(id: :test_component) { 'TestComponent rendered' }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('TestComponent rendered')
    end
  end

  context 'it has state and can' do
    before do
      @doc = visit('/')
    end

    it 'define a default state value and access it' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          state.something = 'Something state intialized!'
          render do
            DIV(id: :test_component) { state.something }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('Something state intialized!')
    end

    it 'define a default state value and change it' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          event_handler :change_state do |event|
            state.something = false
          end
          state.something = true
          render do
            if state.something
              DIV(id: :test_component, on_click: :change_state) { "#{state.something}" }
            else
              DIV(id: :changed_component, on_click: :change_state) { "#{state.something}" }
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('true')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('false')
    end

    it 'use a uninitialized state value and change it' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          event_handler :change_state do |event|
            state.something = true
          end
          render do
            if state.something
              DIV(id: :changed_component, on_click: :change_state) { "#{state.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{state.something}here" }
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('true')
    end
  end

  context 'it accepts props and can' do
    before do
      @doc = visit('/')
    end

    it 'access them' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          render do
            DIV(id: :test_component) do
              SPAN props.text
              SPAN props.other_text
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { text: 'Prop passed!', other_text: 'Passed other prop!' }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      all_text = node.all_text
      expect(all_text).to include('Prop passed!')
      expect(all_text).to include('Passed other prop!')
    end

    it 'access a required, exact type' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          prop :a_prop, class: String
          render do
            DIV(id: :test_component) { props.a_prop.class.to_s }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: 'Prop passed!' }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('String')
    end

    it 'access a required, more generic type' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          prop :a_prop, is_a: Enumerable
          render do
            DIV(id: :test_component) { props.a_prop.class.to_s }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: [1, 2, 3] }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('Array')
    end

    it 'accept a missing prop' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          prop :a_prop, class: String
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
    end

    it 'accept a unwanted type in production' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          prop :a_prop, class: String
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { a_prop: 10 }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothing10here')
    end

    it 'accept a missing, optional prop' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          prop :a_prop, class: String, required: false
          render do
            DIV(id: :test_component) { "nothing#{props.a_prop}here" }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
    end

    it 'uses a default value for a missing, optional prop' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          prop :a_prop, class: String, default: 'Prop not passed!'
          render do
            DIV(id: :test_component) { props.a_prop }
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, { }, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('Prop not passed!')
    end
  end

  context 'it can use callbacks like' do
    before do
      @doc = visit('/')
    end

    it 'component_did_catch' do
      @doc.evaluate_ruby do
        class ComponentWithError < React::Component::Base
          def text
            'Error caught!'
          end
          render do
            DIV(id: :error_component) { send(props.text_method) }
          end
        end
        class TestComponent < React::Component::Base
          render do
            DIV(id: :test_component) { ComponentWithError(text_method: state.text_method) }
          end
          component_did_catch do |error, info|
            state.text_method = :text
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('Error caught!')
    end

    it 'component_did_mount' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          render do
            DIV(id: :test_component) { state.some_text }
          end
          component_did_mount do
            state.some_text = 'some other text'
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('some other text')
    end

    it 'component_did_update' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          render do
            DIV(id: :test_component) { state.some_text }
          end
          component_did_mount do
            state.some_text = 'some other text'
          end
          component_did_update do |prev_props, prev_state, snapshot|
            if prev_state.some_text != '100'
              state.some_text = '100'
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('100')
    end

    it 'component_will_unmount' do
      result = @doc.evaluate_ruby do
        IT = { unmount_received: false }
        class TestComponent < React::Component::Base
          render do
            DIV(id: :test_component) { state.some_text }
          end
          component_will_unmount do
            IT[:unmount_received] = true
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
        ReactDOM.unmount_component_at_node('#test_anchor')
        IT[:unmount_received]
      end
      expect(result).to be true
    end
  end

  context 'it can handle events like' do
    before do
      @doc = visit('/')
    end

    it 'on_click' do
      @doc.evaluate_ruby do
        class TestComponent < React::Component::Base
          event_handler :change_state do |event|
            state.something = true
          end
          render do
            if state.something
              DIV(id: :changed_component, on_click: :change_state) { "#{state.something}" }
            else
              DIV(id: :test_component, on_click: :change_state) { "nothing#{state.something}here" }
            end
          end
        end
        Isomorfeus::TopLevel.mount_component(TestComponent, {}, '#test_anchor')
      end
      node = @doc.wait_for('#test_component')
      expect(node.all_text).to include('nothinghere')
      node.click
      node = @doc.wait_for('#changed_component')
      expect(node.all_text).to include('true')
    end
  end
end
