# The Computer Language Benchmarks Game
# https://benchmarksgame-team.pages.debian.net/benchmarksgame/
#
# translated to Elixir from the Python 3 version (Kevin Carson,
# Tupteq, Fredrik Johansson, Daniel Nanz, Maciej Fijalkowski).
# Single-threaded, deterministic output.

defmodule NBody do
  @pi 3.14159265358979323
  @solar_mass 4 * @pi * @pi
  @days_per_year 365.24

  # Each body is {x, y, z, vx, vy, vz, mass}. Order matches the Python
  # dict insertion order: sun, jupiter, saturn, uranus, neptune.
  defp initial_system do
    {
      {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, @solar_mass},
      {4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
       1.66007664274403694e-03 * @days_per_year, 7.69901118419740425e-03 * @days_per_year,
       -6.90460016972063023e-05 * @days_per_year, 9.54791938424326609e-04 * @solar_mass},
      {8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
       -2.76742510726862411e-03 * @days_per_year, 4.99852801234917238e-03 * @days_per_year,
       2.30417297573763929e-05 * @days_per_year, 2.85885980666130812e-04 * @solar_mass},
      {1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
       2.96460137564761618e-03 * @days_per_year, 2.37847173959480950e-03 * @days_per_year,
       -2.96589568540237556e-05 * @days_per_year, 4.36624404335156298e-05 * @solar_mass},
      {1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
       2.68067772490389322e-03 * @days_per_year, 1.62824170038242295e-03 * @days_per_year,
       -9.51592254519715870e-05 * @days_per_year, 5.15138902046611451e-05 * @solar_mass}
    }
  end

  # x in 0..len-2, y in x+1..len-1
  defp pairs, do: for(i <- 0..3, j <- (i + 1)..4, do: {i, j})

  defp offset_momentum(sys) do
    {px, py, pz} =
      Enum.reduce(0..4, {0.0, 0.0, 0.0}, fn i, {px, py, pz} ->
        {_, _, _, vx, vy, vz, m} = elem(sys, i)
        {px - vx * m, py - vy * m, pz - vz * m}
      end)

    {x, y, z, _, _, _, m} = elem(sys, 0)
    put_elem(sys, 0, {x, y, z, px / m, py / m, pz / m, m})
  end

  defp advance(sys, pairs, dt) do
    sys =
      Enum.reduce(pairs, sys, fn {i, j}, s ->
        {x1, y1, z1, vx1, vy1, vz1, m1} = elem(s, i)
        {x2, y2, z2, vx2, vy2, vz2, m2} = elem(s, j)
        dx = x1 - x2
        dy = y1 - y2
        dz = z1 - z2
        mag = dt * :math.pow(dx * dx + dy * dy + dz * dz, -1.5)
        b1m = m1 * mag
        b2m = m2 * mag

        b1 = {x1, y1, z1, vx1 - dx * b2m, vy1 - dy * b2m, vz1 - dz * b2m, m1}
        b2 = {x2, y2, z2, vx2 + dx * b1m, vy2 + dy * b1m, vz2 + dz * b1m, m2}
        s |> put_elem(i, b1) |> put_elem(j, b2)
      end)

    Enum.reduce(0..4, sys, fn i, s ->
      {x, y, z, vx, vy, vz, m} = elem(s, i)
      put_elem(s, i, {x + dt * vx, y + dt * vy, z + dt * vz, vx, vy, vz, m})
    end)
  end

  defp report_energy(sys, pairs) do
    e =
      Enum.reduce(pairs, 0.0, fn {i, j}, e ->
        {x1, y1, z1, _, _, _, m1} = elem(sys, i)
        {x2, y2, z2, _, _, _, m2} = elem(sys, j)
        dx = x1 - x2
        dy = y1 - y2
        dz = z1 - z2
        e - m1 * m2 / :math.sqrt(dx * dx + dy * dy + dz * dz)
      end)

    e =
      Enum.reduce(0..4, e, fn i, e ->
        {_, _, _, vx, vy, vz, m} = elem(sys, i)
        e + m * (vx * vx + vy * vy + vz * vz) / 2.0
      end)

    IO.puts(:erlang.float_to_binary(e, decimals: 9))
  end

  defp loop(sys, _pairs, _dt, 0), do: sys
  defp loop(sys, pairs, dt, n), do: loop(advance(sys, pairs, dt), pairs, dt, n - 1)

  def run(n) do
    pairs = pairs()
    sys = initial_system() |> offset_momentum()
    report_energy(sys, pairs)
    sys = loop(sys, pairs, 0.01, n)
    report_energy(sys, pairs)
  end
end

n = System.argv() |> hd() |> String.to_integer()
NBody.run(n)
