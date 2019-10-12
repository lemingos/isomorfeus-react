require 'spec_helper'

RSpec.describe 'Server Side Rendering' do
  before do
    @doc = visit('/ssr')
  end
  it 'renders on the server' do
    expect(@doc.html).to include('Rendered!')
  end

  it 'save the application state for the client' do
    node = @doc.find('[data-iso-state]')
    expect(node).to be_truthy
    state_json = node.get_attribute('data-iso-state')
    state = Oj.load(state_json, mode: :strict)
    expect(state).to have_key('application_state')
    expect(state).to have_key('component_state')
    expect(state).to have_key('component_class_state')

    expect(state['application_state']).to have_key('a_value')
    expect(state['application_state']['a_value']).to eq('application store works')
    expect(state['component_class_state']).to have_key('HelloComponent')
    expect(state['component_class_state']['HelloComponent'])
    expect(state['component_class_state']['HelloComponent']['a_value']).to eq('component class store works')
    expect(state['component_class_state']['HelloComponent']).to have_key('instance_defaults')
    expect(state['component_class_state']['HelloComponent']['instance_defaults']).to have_key('a_value')
    expect(state['component_class_state']['HelloComponent']['instance_defaults']['a_value']).to eq('component store works')
  end

  it 'save the application state for the client, also on subsequent renders' do
    # just the same as above, just a second time, just to see if the store is initialized correctly
    node = @doc.find('[data-iso-state]')
    expect(node).to be_truthy
    state_json = node.get_attribute('data-iso-state')
    state = Oj.load(state_json, mode: :strict)
    expect(state).to have_key('application_state')
    expect(state).to have_key('component_state')
    expect(state).to have_key('component_class_state')

    expect(state['application_state']).to have_key('a_value')
    expect(state['application_state']['a_value']).to eq('application store works')
    expect(state['component_class_state']).to have_key('HelloComponent')
    expect(state['component_class_state']['HelloComponent'])
    expect(state['component_class_state']['HelloComponent']['a_value']).to eq('component class store works')
    expect(state['component_class_state']['HelloComponent']).to have_key('instance_defaults')
    expect(state['component_class_state']['HelloComponent']['instance_defaults']).to have_key('a_value')
    expect(state['component_class_state']['HelloComponent']['instance_defaults']['a_value']).to eq('component store works')
  end

  it 'it returns 404 if page not found' do
    # just the same as above, just a second time, just to see if the store is initialized correctly
    @doc = visit('/whatever')
    expect(@doc.response.status).to eq(404)
  end
end