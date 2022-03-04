defmodule Ppc.Plan.PlanPrototype do
  alias Ppc.Plan.{BillingCycle, PaymentPreferences, Taxes}

  @moduledoc """
  Used to craete a plan.
  """

  defstruct [
    :product_id,
    :name,
    :description,
    :status,
    :billing_cycles,
    :payment_preferences,
    :taxes,
    :quantity_supported
  ]

  @type plan_status :: :created | :active | :inactive

  @type t :: %__MODULE__{
          product_id: String.t() | nil,
          name: String.t(),
          description: String.t(),
          status: plan_status(),
          billing_cycles: [BillingCycle.t()],
          payment_preferences: PaymentPreferences.t(),
          taxes: Taxes.t(),
          quantity_supported: boolean()
        }

  @doc """
  Creates a plan prototype that can be used as paylod when creating new paypal plan.

  ## Notes

  When creating status can only be `:created` or `:active`.

  ## Examples

      tiers = [
        PricingTier.new("1", "99", Money.new("EUR", "1.00")),
        PricingTier.new("100", "199", Money.new("EUR", "2.00")),
        PricingTier.new("200", "", Money.new("EUR", "3.00"))
      ]

      scheme1 = PricingScheme.new(1, Money.new("EUR", "1.00"), :tiered, tiers)
      freq1 = Frequency.new(:month, 1)

      cycles = [
        BillingCycle.new(scheme1, freq1, :regular, 1, 0)
      ]

      prefs = PaymentPreferences.new(true, Money.new("EUR", "0.00"), :continue, 2)
      taxes = Taxes.new("10.5", true)

      proto =
        PlanPrototype.new(
          "PROD-aabbcc",
          "Base Sticker Plan",
          "Base plan for stickers",
          :active,
          cycles,
          prefs,
          taxes,
          false
        )

  """
  @spec new(
          String.t(),
          String.t(),
          String.t(),
          plan_status(),
          [BillingCycle.t()],
          PaymentPreferences.t(),
          Taxes.t(),
          boolean
        ) :: __MODULE__.t()
  def new(id, name, descr, status, cycles, prefs, taxes, quantity_support) do
    %__MODULE__{
      product_id: id,
      name: name,
      description: descr,
      status: status,
      billing_cycles: cycles,
      payment_preferences: prefs,
      taxes: taxes,
      quantity_supported: quantity_support
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(value, opts) do
      {_, value} =
        Map.drop(value, [:__struct__])
        |> Map.get_and_update(:plan_status, fn v ->
          v = if is_nil(v), do: :created, else: v
          {v, Atom.to_string(v) |> String.upcase()}
        end)

      Jason.Encode.map(value, opts)
    end
  end

  @doc """
  This function will try to fix or warn common mistakes when creating a new plan.

  At this moment this function does notthing.
  """
  def prepare_for_transmission(data) do
    data
  end
end
