module LucidComponent
  module Mixin
    def self.included(base)
      base.include(::Native::Wrapper)
      base.extend(::LucidComponent::NativeComponentConstructor)
      base.extend(::LucidPropDeclaration::Mixin)
      base.extend(::LucidComponent::EventHandler)
      base.include(::React::Component::Elements)
      base.include(::React::Component::API)
      base.include(::React::Component::Callbacks)
      base.include(::LucidComponent::StoreAPI)
      base.include(::LucidComponent::StylesSupport)
      base.include(::LucidComponent::Initializer)
      base.include(::React::Component::Features)
      base.include(::React::Component::Resolution)
    end
  end
end
