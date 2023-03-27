defmodule Mix.Tasks.UpdateReadmeOutline do
  @moduledoc "Update outline for README.md."
  @shortdoc @moduledoc

  use Mix.Task

  @readme_path "../README.md"
  @course_outline_path "../start.livemd"
  @ignored_sections ["## Overview", "### Welcome"]

  def run(_args) do
    IO.puts("Running: mix update_readme_outline")

    readme = File.read!(@readme_path)

    content =
      Regex.replace(
        ~r/<!-- course-outline-start -->(?:.|\n)*<!-- course-outline-end -->/,
        readme,
        """
        <!-- course-outline-start -->
        #{outline_snippet()}
        <!-- course-outline-start -->
        """
      )

    File.write!(@readme_path, content)
  end

  @spec outline_snippet() :: String.t()
  def outline_snippet do
    outline = File.read!(@course_outline_path)

    Regex.scan(~r/(\#{2,3})(.+)/, outline)
    |> Enum.reject(fn [full, _, _] -> full in @ignored_sections end)
    |> Enum.map(fn
      [full, "##", _heading] -> full <> "\n"
      [_, "###", subheading] -> "*#{subheading}\n"
    end)
    |> Enum.join()
  end
end
