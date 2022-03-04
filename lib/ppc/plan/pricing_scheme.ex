defmodule Ppc.Plan.PricingScheme do
  @moduledoc """
  ## Reference
  - [Pricing Scheme docs](https://developer.paypal.com/api/subscriptions/v1/#definition-pricing_scheme)
  """

  alias Ppc.Plan.{PricingTier, Money}

  defstruct [:version, :fixed_price, :pricing_model, :tiers]

  @type pricing_model :: nil | :volume | :tiered

  @type t :: %__MODULE__{
          version: integer,
          fixed_price: Money.t(),
          pricing_model: pricing_model(),
          tiers: [PricingTier.t()] | nil
        }

  @doc """
  ### Argument notes:

  - fixed_price – fixed amount to charge for the subscription. This can be updated for
    existing and future subscriptions.
  - pricing_model - is the pricing model for tiered plan; the tiers parameter is required.
    If this field is omitted you don't need to provide tiers.
  """
  # @spec new(integer, Money.t(), String.t(), [PricingTier.t()]) :: __MODULE__.t()
  # @spec new(integer, Money.t(), String.t(), [PricingTier.t()], integer) :: __MODULE__.t()
  @spec new(
          integer,
          Money.t(),
          pricing_model(),
          [PricingTier.t()] | nil
        ) :: __MODULE__.t()
  def new(version, fixed_price, model, tiers) do
    %__MODULE__{
      version: version,
      fixed_price: fixed_price,
      pricing_model: model,
      tiers: tiers
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      {_, value} =
        Map.drop(value, [:__struct__])
        |> Map.get_and_update(:pricing_model, fn v ->
          if is_nil(v), do: :pop, else: {v, Atom.to_string(v) |> String.upcase()}
        end)

      Jason.Encode.map(value, opts)
    end
  end
end
