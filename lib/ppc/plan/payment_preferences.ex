defmodule Ppc.Plan.PaymentPreferences do
  alias Ppc.Plan.Money

  defstruct [
    :auto_bill_outstanding,
    :setup_fee,
    :setup_fee_failure_action,
    :payment_failure_threshold
  ]

  @type failure_action :: :continue | :cancel
  @type t :: %__MODULE__{
          auto_bill_outstanding: boolean(),
          setup_fee: Money.t(),
          setup_fee_failure_action: failure_action(),
          payment_failure_threshold: 2
        }

  @doc """
  Attributes:
  - auto: if true will automatically bill the outstanding amount in the next billing cycle.
  - setup_fee: the initial set-up fee for the service.
  - failure_action: how to act on failed initial payment for the setup. Possible values:
    - :continue - continues the subscription
    - :cancel - cancels the subscription if the initial payment for the ssetup fails.
  - failure_threshold - maximum number of consecutive payment failures before a subscription is suspended.
  """
  @spec new(boolean, Money.t(), failure_action(), integer) :: __MODULE__.t()
  def new(auto, setup_fee, action, failure_threshold) do
    %__MODULE__{
      auto_bill_outstanding: auto,
      setup_fee: setup_fee,
      setup_fee_failure_action: action,
      payment_failure_threshold: failure_threshold
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      {_, value} =
        Map.drop(value, [:__struct__])
        |> Map.get_and_update(:setup_fee_failure_action, fn v ->
          {v, Atom.to_string(v) |> String.upcase()}
        end)

      Jason.Encode.map(value, opts)
    end
  end
end
