defmodule Ppc.Subscription.ApplicationContext do
  alias Ppc.Subscription.{PaymentMethod}

  defstruct [
    :brand_name,
    :locale,
    :shipping_preference,
    :user_action,
    :payment_method,
    :return_url,
    :cancel_url
  ]

  @type user_action :: :continue | :subscribe_now
  @type shipping_preference :: :get_from_file | :no_shipping | :set_provided_address

  @type t :: %__MODULE__{
          brand_name: String.t(),
          locale: String.t(),
          shipping_preference: shipping_preference,
          user_action: user_action,
          payment_method: PaymentMethod.t(),
          return_url: String.t(),
          cancel_url: String.t()
        }
end
