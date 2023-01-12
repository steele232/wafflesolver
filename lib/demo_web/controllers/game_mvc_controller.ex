defmodule DemoWeb.GameMvcController do
  use DemoWeb, :controller

  alias Demo.Waffle.Board
  alias Demo.Waffle

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def solved(conn, params=%{
    "v1h1" => v1h1,
    "v1h2" => v1h2,
    "v1h3" => v1h3,
    "v1h4" => v1h4,
    "v1h5" => v1h5,
    "v2h1" => v2h1,
    "v2h3" => v2h3,
    "v2h5" => v2h5,
    "v3h1" => v3h1,
    "v3h2" => v3h2,
    "v3h3" => v3h3,
    "v3h4" => v3h4,
    "v3h5" => v3h5,
    "v4h1" => v4h1,
    "v4h3" => v4h3,
    "v4h5" => v4h5,
    "v5h1" => v5h1,
    "v5h2" => v5h2,
    "v5h3" => v5h3,
    "v5h4" => v5h4,
    "v5h5" => v5h5,
    "v1h1Num" => v1h1Num,
    "v1h2Num" => v1h2Num,
    "v1h3Num" => v1h3Num,
    "v1h4Num" => v1h4Num,
    "v1h5Num" => v1h5Num,
    "v2h1Num" => v2h1Num,
    "v2h3Num" => v2h3Num,
    "v2h5Num" => v2h5Num,
    "v3h1Num" => v3h1Num,
    "v3h2Num" => v3h2Num,
    "v3h3Num" => v3h3Num,
    "v3h4Num" => v3h4Num,
    "v3h5Num" => v3h5Num,
    "v4h1Num" => v4h1Num,
    "v4h3Num" => v4h3Num,
    "v4h5Num" => v4h5Num,
    "v5h1Num" => v5h1Num,
    "v5h2Num" => v5h2Num,
    "v5h3Num" => v5h3Num,
    "v5h4Num" => v5h4Num,
    "v5h5Num" => v5h5Num,
  }) do
    IO.inspect("params below")
    IO.inspect(params)
    submittedBoard = %Board{
      characterStrings: [
        [v1h1, v1h2, v1h3, v1h4, v1h5],
        [v2h1, " ", v2h3, " ", v2h5],
        [v3h1, v3h2, v3h3, v3h4, v3h5],
        [v4h1, " ", v4h3, " ", v4h5],
        [v5h1, v5h2, v5h3, v5h4, v5h5]
      ],
      feedbackStrings: [
        [v1h1Num, v1h2Num, v1h3Num, v1h4Num, v1h5Num],
        [v2h1Num, " ", v2h3Num, " ", v2h5Num],
        [v3h1Num, v3h2Num, v3h3Num, v3h4Num, v3h5Num],
        [v4h1Num, " ", v4h3Num, " ", v4h5Num],
        [v5h1Num, v5h2Num, v5h3Num, v5h4Num, v5h5Num]
      ]
    }
    solutions = Waffle.solve([submittedBoard])
    IO.inspect("dunbinsolved")
    IO.inspect solutions
    solutionsString = Kernel.inspect(solutions)
    render(conn, "solved.html", %{
      solved_term_to_string: solutionsString,
      solutions: solutions
      })
  end
end
