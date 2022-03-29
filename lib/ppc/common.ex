defmodule Ppc.Common do
  @doc """
  To update a paypal entity we need to provide each mutated field with correct annotations.

  The plan:

    - compare fields of old entity with new one. Obtain a list of entries
      (aka. update-list or update-triplets):
      - operation (one of {add|remove|replace})
      - field-name
      - new-value (if applicable)
    - consume triplets and create update operations; that will be the request body.
      -> It's this function implementation.
    - make request to the api

  An update operation requires each field to be annotated with mutation kind that will
  be performed:

    - add
    - remove
    - replace

  When no change is made omit the operation

  Everything else will invalidate the request.
  """
  def extract_field_changes(prev, next, accepted_fields) do
    ensure_str = fn x -> if is_atom(x), do: Atom.to_string(x), else: x end

    prev = Map.new(prev, fn {k, v} -> {ensure_str.(k), v} end)

    map_to_op = fn key, v_next ->
      key_a = ensure_str.(key)
      v_prev = Map.get(prev, key_a, "")

      case {v_prev, v_next} do
        {"", ""} ->
          nil

        {"", _} ->
          {"add", key, v_next}

        {_, ""} ->
          {"remove", key, nil}

        _ ->
          {"replace", key, v_next}
      end
    end

    oplist =
      next
      |> Enum.map(fn {k, v} -> map_to_op.(k, v) end)
      |> Enum.filter(&(!is_nil(&1)))
      |> Enum.filter(fn {_op, k, _v} -> k in accepted_fields end)

    oplist
  end

  @doc """
  Paypal accepts changes as a list of objects with fields: 'op', 'path', and 'value'.
  In Elixir we can construct it as following list:

      [%{op: "remove", path: "/a"}, %{op: "replace", path: "/b", value: 3}]

  """
  def construct_update_operations(triplets) do
    path_normalize = fn p ->
      path = if is_atom(p), do: Atom.to_string(p), else: String.replace(p, ".", "/")
      "/" <> path
    end

    map_to_dict = fn triplet ->
      case triplet do
        {op, k, v} ->
          %{op: op, path: path_normalize.(k), value: v}

        {remove, k} when remove in [:remove, "remove"] ->
          %{op: "remove", path: path_normalize.(k)}
      end
    end

    Enum.map(triplets, &map_to_dict.(&1))
  end

  def construct_headers_for_create(opts) do
    headers = []
    headers = if opts[:mini], do: headers ++ [{"Prefer", "return=minimal"}], else: headers
    headers = if opts[:full], do: headers ++ [{"Prefer", "return=representation"}], else: headers
    headers = if opts[:idem], do: headers ++ [{"PayPal-Request-Id", opts[:idem]}], else: headers
    headers
  end

  @doc """
  Iterates a map ensuring each value that is an atom is converted to an uppercase string.
  Does not visit nested maps.
  """
  @spec normalize_atom_values(map) :: map
  def normalize_atom_values(map) do
    ensure_upcase_str = fn x ->
      if is_atom(x) && !is_boolean(x), do: Atom.to_string(x) |> String.upcase(), else: x
    end

    Map.new(map, fn {k, v} -> {k, ensure_upcase_str.(v)} end)
  end

  def to_map_if_struct(x) do
    if is_struct(x), do: Map.from_struct(x), else: x
  end

  @spec flat_keys(map) :: map
  def flat_keys(map) do
    consume_map(map, %{})
  end

  defp consume_map(map, acc_in, path \\ nil) do
    Enum.reduce(map, acc_in, fn {k, v}, acc ->
      # We need all keys to be strings
      path_next = if is_atom(k), do: Atom.to_string(k), else: k
      path_next = if is_nil(path), do: path_next, else: Enum.join([path, path_next], ".")

      if is_map(v) do
        # treat all structs as maps
        v = to_map_if_struct(v)
        consume_map(v, acc, path_next)
      else
        Map.put(acc, path_next, v)
      end
    end)
  end

  @doc """
  Calculate new DateTime instance.
  Arguments:
    - days: integer - number of days to add/subtract;
    - ref_date: DateTime - reference time point, if null then DateTime.utc_now is used.
  """
  def datetime_add_days(days, ref_date \\ nil) do
    ref_date = if ref_date, do: ref_date, else: DateTime.utc_now()

    ref_date
    |> DateTime.add(days * 24 * 60 * 60, :second)
    |> DateTime.to_iso8601()
    |> String.split(".", parts: 2)
    |> Enum.at(0)
    # |> (&(&1 <> "Z")).()
    |> (&(&1 <> ".940Z")).()
  end
end
