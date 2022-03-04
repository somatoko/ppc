defmodule Ppc.Subscription.SubscriberRequest do
  alias Ppc.Subscription.{PayerName, PhoneWithType, ShippingDetail}

  defstruct [
    :name,
    :email_address,
    :payer_id,
    :phone,
    :shipping_address,
    :payment_source
  ]

  @type t :: %__MODULE__{
          name: PayerName.t(),
          email_address: String.t(),
          payer_id: String.t(),
          phone: PhoneWithType.t(),
          shipping_address: ShippingDetail.t(),
          payment_source: any
        }
end
