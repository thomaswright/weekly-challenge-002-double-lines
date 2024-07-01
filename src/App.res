type orientation = TR | BR | TL | BL

let cornerOrientation = (ax, ay, cx, cy, mod) => {
  switch (cx > ax, cy > ay, mod) {
  | (true, true, true) => TR
  | (true, true, false) => BL
  | (true, false, true) => BR
  | (true, false, false) => TL
  | (false, true, true) => TL
  | (false, true, false) => BR
  | (false, false, true) => BL
  | (false, false, false) => TR
  }
}

let toString = Belt.Int.toString

let intAbs = a => Math.abs(a->Int.toFloat)->Float.toInt

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
  ]

  let box = (t, l, h, w, c) => {
    <div
      style={{
        position: "fixed",
        top: t->toString ++ "px",
        left: l->toString ++ "px",
        backgroundColor: c,
        height: h->toString ++ "px",
        width: w->toString ++ "px",
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
        | (Some((bx, by)), Some((cx, cy))) => {
            let w = intAbs(bx - ax)
            let h = intAbs(by - ay)
            let horz = mod(i, 2) == 0

            let edges = horz
              ? bx > ax
                  ? [box(ay, ax, t, w, red), box(ay - t, ax, t, w, blue)]
                  : [box(by - t, bx, t, w, red), box(by, bx, t, w, blue)]
              : by > ay
              ? [box(ay, ax, h, t, blue), box(ay, ax - t, h, t, red)]
              : [box(by, bx - t, h, t, blue), box(by, bx, h, t, red)]

            let corner = switch cornerOrientation(ax, ay, cx, cy, horz) {
            | TR => [box(by - t, bx, t, t, horz ? blue : red)]
            | BR => [box(by, bx, t, t, horz ? red : blue)]
            | TL => [box(by - t, bx - t, t, t, horz ? red : blue)]
            | BL => [box(by, bx - t, t, t, horz ? blue : red)]
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
