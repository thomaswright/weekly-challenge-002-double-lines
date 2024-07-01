@react.component
let make = () => {
  let points = [
    (100, 100),
    (500, 100),
    (500, 400),
    (300, 400),
    (300, 600),
    (1000, 600),
    (1000, 200),
    (200, 200),
    (200, 100),
  ]

  let box = (t, l, h, w, c) => {
    <div
      style={{
        position: "fixed",
        top: t->Belt.Int.toString ++ "px",
        left: l->Belt.Int.toString ++ "px",
        backgroundColor: c,
        height: h->Belt.Int.toString ++ "px",
        width: w->Belt.Int.toString ++ "px",
      }}
    />
  }

  let t = 10 // thickness
  let red = "#f87171"
  let blue = "#3730a3"

  <div className="p-6">
    {points
    ->Array.reduceWithIndex([], (arr, cur, i) => {
      let (ax, ay) = cur

      arr->Array.concat(
        switch (points->Array.get(i + 1), points->Array.get(i + 2)) {
        | (Some((bx, by)), c) => {
            let w = Math.abs((bx - ax)->Int.toFloat)->Float.toInt
            let h = Math.abs((by - ay)->Int.toFloat)->Float.toInt
            let horz = mod(i, 2) == 0

            let edges = horz
              ? bx > ax
                  ? [box(ay, ax, t, w, red), box(ay - t, ax, t, w, blue)]
                  : [box(by - t, bx, t, w, red), box(by, bx, t, w, blue)]
              : by > ay
              ? [box(ay, ax, h, t, blue), box(ay, ax - t, h, t, red)]
              : [box(by, bx - t, h, t, blue), box(by, bx, h, t, red)]

            let corner = switch c {
            | Some((cx, cy)) =>
              switch (cx > ax, cy > ay, horz) {
              | (true, true, true) => [box(by - t, bx, t, t, blue)]
              | (false, false, false) => [box(by - t, bx, t, t, red)]
              | (false, true, true) => [box(by - t, bx - t, t, t, red)]
              | (true, false, false) => [box(by - t, bx - t, t, t, blue)]
              | (true, false, true) => [box(by, bx, t, t, red)]
              | (false, true, false) => [box(by, bx, t, t, blue)]
              | (false, false, true) => [box(by, bx - t, t, t, blue)]
              | (true, true, false) => [box(by, bx - t, t, t, red)]
              }

            | None => []
            }
            Array.concat(edges, corner)
          }

        | _ => [React.null]
        },
      )
    })
    ->React.array}
  </div>
}
