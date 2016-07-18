defmodule Tube.Context do

  @type values :: %{atom => any}
  @type halted :: boolean
  @type t :: %__MODULE__{
    values: values,
    halted: halted
  }

  defstruct values: %{},
            halted: false


  @spec assign(t, atom, term) :: t
  def assign(%__MODULE__{values: values} = context, key, value) when is_atom(key) do
    %{context | values: Map.put(values, key, value)}
  end

  @spec assign(t, atom, term, [if: (->boolean)]) :: t
  def assign(context, key, value, [if: if_fun]) when is_atom(key) do
    if if_fun.() do
      assign(context, key, value)
    else
      context
    end
  end

  @spec assign(t, atom, term, [unless: (->boolean)]) :: t
  def assign(context, key, value, [unless: unless_fun]) when is_atom(key) do
    unless unless_fun.() do
      assign(context, key, value)
    else
      context
    end
  end

  @spec fetch(t, atom) :: {:ok, term} | :error
  def fetch(%__MODULE__{values: values}, key) when is_atom(key) do
    Map.fetch(values, key)
  end

  @spec fetch!(t, atom) :: term | no_return
  def fetch!(%__MODULE__{values: values}, key) when is_atom(key) do
    Map.fetch!(values, key)
  end

  @spec get(t, atom, term) :: term
  def get(%__MODULE__{values: values}, key, default \\ nil) when is_atom(key) do
    Map.get(values, key, default)
  end

  @spec get_all(t, [atom]) :: Map.t
  def get_all(%__MODULE__{values: values}, keys) when is_list(keys) do
    Enum.reduce(keys, Map.new, fn key, acc ->
      case Map.get(values, key) do
        nil -> acc
        value -> Map.put(acc, key, value)
      end
    end)
  end

  @spec context(map) :: t
  def context(map) when is_map(map) do
    %__MODULE__{values: map}
  end

  @spec context(list) :: t
  def context(kv) when is_list(kv) do
    %__MODULE__{values: Enum.into(kv, %{})}
  end

  @spec halt(t) :: t
  def halt(context) do
    %{context | halted: true}
  end
end
