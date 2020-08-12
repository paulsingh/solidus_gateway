module SpreeGateway
  class Engine < Rails::Engine
    engine_name 'solidus_gateway'

    initializer "spree.gateway.payment_methods", :after => "spree.register.payment_methods" do |app|
        app.config.spree.payment_methods << Spree::Gateway::AuthorizeNetCim
        app.config.spree.payment_methods << Spree::Gateway::AuthorizeNet
    end

    # The application_id is a class attribute on all gateways and is used to
    # identify the "source" of the transaction. Braintree has asked us to
    # provide this value to attribute transactions to Solidus; we do not set
    # it on all gateways or the base gateway as other gateways' behavior with
    # the value may differ.
    initializer "spree.gateway.braintree_gateway.application_id" do |app|
      # NOTE: if the braintree gem is not loaded, calling ActiveMerchant::Billing::BraintreeBlueGateway crashes
      # therefore, check here to see if Braintree exists before trying to call it
      if defined?(Braintree)
        ActiveMerchant::Billing::BraintreeBlueGateway.application_id = "Solidus"
      end
    end

    if SolidusSupport.backend_available?
      paths["app/views"] << "lib/views/backend"
    end

    if SolidusSupport.frontend_available?
      paths["app/views"] << "lib/views/frontend"
    end

    if SolidusSupport.api_available?
      paths["app/views"] << "lib/views/api"
    end
  end
end
