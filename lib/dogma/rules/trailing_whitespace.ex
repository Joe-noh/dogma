defmodule Dogma.Rules.TrailingWhitespace do
  alias Dogma.Script
  alias Dogma.Error

  @regex ~r/\s+\z/

  def test(script) do
    Enum.reduce( script.lines, script, &check_line(&1, &2) )
  end

  defp check_line({i, line}, script) do
    case Regex.run( @regex, line, return: :index ) do
      [{x, _}] -> Script.register_error( script, error(x, i) )
      nil      -> script
    end
  end

  defp error(col, pos) do
    %Error{
      rule:     __MODULE__,
      message:  "Trailing whitespace detected [#{col}]",
      position: pos,
    }
  end
end
