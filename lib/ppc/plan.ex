defmodule Ppc.Plan do
  @moduledoc """
  Manage product plans.

  ## Reference

  - [Plan docs](https://developer.paypal.com/api/subscriptions/v1/#plans_list)
  """

  alias Ppc.{Account, Client, Common}

  @path "/v1/billing/plans"

  @doc """
  Get list of plans.

  ## Accepted options
  - :params with accepted values
    - :product_id - filter returned list
    - :plan_id - filter by list of plan IDs; max 10 plan IDs.
    - :page_size
    - :page
    - :total_required
  - :mini
  - :full

  ## Returned value

      {:ok, %{
        links: [
          %{ encType: "", href: "", method: "GET", rel: "self" }
        ],
        plans: [ -- list of plans -- ]
        }
      }

  Each plan has a following structure

      %{
        create_time: "2021-08-27T19:29:54Z",
        description: "Basic",
        id: "P-3A536606RU4549013MEUT2MQ",
        links: [
          %{
            encType: "application/json",
            href: "https://api.sandbox.paypal.com/v1/billing/plans/P-3A536606RU4549013MEUT2MQ",
            method: "GET",
            rel: "self"
          }
        ],
        name: "UtilityManager - Basic",
        status: "INACTIVE",
        usage_type: "LICENSED"
      }
  """
  @spec list(Account.t(), keyword) :: any
  def list(account, opts \\ []) do
    url = if opts[:product_id], do: @path <> "?product_id=#{opts[:product_id]}", else: @path
    Client.get(account, url, opts)
  end

  @spec details(Account.t(), String.t()) :: any
  def details(account, id) do
    url = @path <> "/#{id}"
    Client.get(account, url)
  end

  @doc """
  Create a plan with pricing and billing cycles for subscriptions.

  ## Body data

  Fields marked with * are required.

  - product_id*
  - name*
  - status allowed values `{CREATED|INACTIVE|ACTIVE}`. Subscriptions can be created only for ACTIVE plans.
  - description
  - billing_cycles*
  - payment_preferences*
  - taxes
  - quantity_supported

  ## Some important rules

    - To create a plan `:product_id` must be valid.
    - For tiered or volume plans `:fixed_price` field must be `nil`.
    - For tiered or volume plans `:quantity_supported` must be always `true`.

  ## Error results

    ```
    {:error, reason}
    ```
  """
  @spec create(Account.t(), map) :: any
  @spec create(Account.t(), map, keyword) :: any
  def create(account, data, opts \\ []) do
    Client.post(
      account,
      @path,
      Ppc.Plan.PlanPrototype.prepare_for_transmission(data),
      headers: Common.construct_headers_for_create(opts)
    )
  end

  @doc """
  Update description, taxes or payment preferences of a plan.

  ## Example

      updates = %{
        description: "updated description",
        payment_preferences: %{
          auto_bill_outstanding: true,
          payment_failure_threshold: 2,
          setup_fee: Money.new("EUR", "1.01"),
          setup_fee_failure_action: :cancel
        },
        taxes: %{percentage: "21"}
      }

      Plan.update(account, id, updates)
  """
  @spec update(Account.t(), String.t(), map) :: any
  def update(account, id, data) do
    accepted_fields = [
      "description",
      "payment_preferences.auto_bill_outstanding",
      "taxes.percentage",
      "payment_preferences.payment_failure_threshold",
      "payment_preferences.setup_fee",
      "payment_preferences.setup_fee_failure_action"
    ]

    {:ok, prev} = details(account, id)

    # Do not flatten money struct/map
    {fee_new, data} = pop_in(data, [:payment_preferences, :setup_fee])
    {fee_prev, prev} = pop_in(prev, [:payment_preferences, :setup_fee])

    data =
      Common.flat_keys(data)
      |> Map.put("payment_preferences.setup_fee", Common.to_map_if_struct(fee_new))
      |> Common.normalize_atom_values()

    prev_data =
      Map.take(prev, [:description, :payment_preferences, :taxes])
      |> Common.flat_keys()
      |> Map.put("payment_preferences.setup_fee", fee_prev)
      |> Map.take(accepted_fields)

    changes =
      Common.extract_field_changes(prev_data, data, accepted_fields)
      |> Common.construct_update_operations()

    Client.patch(account, @path <> "/#{id}", changes)
  end

  @spec activate(Account.t(), String.t()) :: any
  def activate(account, id) do
    url = @path <> "/#{id}/activate"
    Client.post(account, url, nil)
  end

  @spec deactivate(Account.t(), String.t()) :: any
  def deactivate(account, id) do
    url = @path <> "/#{id}/deactivate"
    Client.post(account, url, nil)
  end

  @doc """
  Update pricing scheme for each existing billing cycle.

  The full plan structure has the following shape:

      id
      product_id
      status
      ...
      billing_cycles: []

  Where each billing cycle is:

      frequency
      tenure_type
      sequence
      total_cycles
      pricing_scheme
        fixed_price
          value
          currency_code

  But the update object for the pricing scheme has a different shape:

      pricing_schemes: [list of update_pricing_scheme]

  Definition of update_pricing_scheme:

      * billing_cycle_sequence: integer
      * pricing_scheme: object

  Definition of pricing_scheme:

      version: integer
      fixed_price: object
      pricing_model: enum {VOLUME|TIERED}
      tiers: [pricing_tier]
      - create_time: string / r-o
      - update_time: string / r-o

  Definition of pricing_tier:

      * starting_quantity: string
      ending_quantity: string
      amount: Money

  ## Some rules

    - Tiers can be added or removed by redefining the complete tiers list, but the range of value
      that those tiers cover in total must be same as the previous one. For example if tho old tiers
      defined a price for infinitely large amount and the new tiers defined tiers to max of 200 units,
      that would result in an error.
    - Fixed price is not supported for tiered pricing schemes.
    - It's impossible to add new schemes because frequency of each can't be changed iether.

  """
  @spec update_pricing(Account.t(), String.t(), map) :: any
  def update_pricing(account, id, data) do
    url = @path <> "/#{id}/update-pricing-schemes"
    Client.post(account, url, data)
  end
end
