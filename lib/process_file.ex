defmodule ProcessFile do

  @filename "file.csv"
  @asciilimit ?À

  def start() do

    message_text = "[Natura] {message}"
    comma = :binary.compile_pattern(",")

    headers =
      File.open!(@filename)
      |> IO.read(:line)
      |> String.replace(~r/\n|\s/, "")
      |> String.split(",")

    headers = headers ++ ["line_number"]

    File.stream!(@filename, [], :line)
    |> Stream.with_index()
    |> Flow.from_enumerable()
    |> Flow.map(fn {line, n} ->
      Enum.zip(headers, String.split(String.replace(line, ~r/\n|\s/, ""), comma) ++ [n])
      |> Enum.into(%{})
    end)
    |> Enum.into([])
  end
end

ProcessFile.start
