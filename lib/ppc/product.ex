defmodule Ppc.Product do
  @moduledoc """
  Documentation for Ppc.Product
  """
  alias Ppc.{Client, Common}

  @path "/v1/catalogs/products"

  @doc """
  List catalog products.

  [docs](https://developer.paypal.com/api/catalog-products/v1/#products)

  Can accept additional parameters under :params key:
    - page_size      - integer, default is 10
    - page           - integer, default is 1
    - total_required - boolean, default is false

  Example:

      result = Product.list(account, params: [page_size: 2, page: 2, total_required: true])

  On success returns

      {:ok, %{
        links: [..],
        products: [..],
        total_items: number, // only if :total_required is supplied
        total_pages: number, // only if :total_required is supplied
      }}

  Where product entry is a map

      %{
        id: string,
        name: string,
        created_time: "2021-08-30T13:29:56Z",
        links: %{href: _, method: _, rel: _}
      }
  """
  @spec list(keyword()) :: any
  def list(opts \\ []) do
    Client.get(@path, opts)
  end

  @doc """
  Get product details
    [docs](https://developer.paypal.com/api/catalog-products/v1/#products_get)

  Return value

      {:ok, product}

  Where product is a map

      %{
        id: "PROD-4DD50056M0813454X",
        name: "Video Streaming Service",
        description: "On-demand video streaming service",
        category: "SERVICES",
        type: "SERVICE",
        home_url: "https://example.com/home",
        image_url: "https://example.com/streaming.png",
        links: [
          %{
            href: "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-4DD50056M0813454X",
            method: "GET",
            rel: "self"
            },
            %{
              href: "https://api.sandbox.paypal.com/v1/catalogs/products/PROD-4DD50056M0813454X",
              method: "PATCH",
              rel: "edit"
            }
        ],
        create_time: "2021-06-14T11:37:23Z",
        update_time: "2021-08-28T15:30:21Z"
      }
  """
  @spec details(String.t()) :: any
  def details(id, opts \\ []) do
    Client.get("#{@path}/#{id}", opts)
  end

  @doc """
  Create product entity.

  ## Accepted options:
  - full: boolean - will add Prefer: return=representation header
  - idem: string - will add PayPal-Request-Id with provided value header

  ## Accepted fields for the new entity
  - id: string? length ∈ [6, 50], if omitted system will generate automatically with 'PROD-' prefix.
  - name: string length ∈ [1, 127]
  - description: string? length ∈ [1, 256]
  - type: enum-string - the product type {PHYSYCAL, DIGITAL, SERVICE}
  - category: enum-string? - the product category (see docs for the full list of possible values)
  - image_url: string? length ∈ [1, 2000]
  - home_url: string? length ∈ [1, 2000]

  ## Return value
  TODO

  ## Reference
  - [Create API docs](https://developer.paypal.com/api/catalog-products/v1/#products_create)
  """
  @spec create(map) :: any
  @spec create(map, keyword) :: any
  def create(data, opts \\ []) do
    headers = Common.construct_headers_for_create(opts)

    # Omit empty fields
    data =
      data
      |> Enum.filter(fn {_k, v} -> v != "" end)
      |> Map.new()

    Client.post(@path, data, headers: headers)
  end

  @doc """
  Update existing product entity. [docs](https://developer.paypal.com/api/catalog-products/v1/#products_patch)

  ## Fields that can be updated (added, replaced or removed):

    - description
    - category
    - image_url
    - home_url

  Fields that are removed (set equal to empty string) will not show up in product details.

  ## Return value
    - `{:ok, :no_content}`
    - `{:error, reason}`
  """
  @spec update(String.t(), map, keyword) :: {:ok, map} | {:error, any}
  def update(id, product, opts) do
    {:ok, prev} = details(id, opts)

    changes =
      Common.extract_field_changes(prev, product, [:description, :category, :image_url, :home_url])
      |> Common.construct_update_operations()

    Client.patch(@path <> "/#{id}", changes, opts)
  end
end
