public class MKAverage
{
    private const int MaxValue = 100000;

    private readonly int m;
    private readonly int k;
    private readonly int[] window;
    private readonly int[] countTree = new int[MaxValue + 1];
    private readonly long[] sumTree = new long[MaxValue + 1];

    private int size;
    private int nextIndex;

    public MKAverage(int m, int k)
    {
        this.m = m;
        this.k = k;
        window = new int[m];
    }

    public void AddElement(int num)
    {
        if (size == m)
        {
            Update(window[nextIndex], -1);
        }
        else
        {
            size++;
        }

        window[nextIndex] = num;
        nextIndex = (nextIndex + 1) % m;
        Update(num, 1);
    }

    public int CalculateMKAverage()
    {
        if (size < m)
            return -1;

        long middleSum = SumSmallest(m - k) - SumSmallest(k);
        return (int)(middleSum / (m - 2 * k));
    }

    private void Update(int value, int delta)
    {
        for (int i = value; i <= MaxValue; i += i & -i)
        {
            countTree[i] += delta;
            sumTree[i] += (long)value * delta;
        }
    }

    private long SumSmallest(int amount)
    {
        int index = 0;
        long sum = 0;

        for (int step = 1 << 16; step > 0; step >>= 1)
        {
            int next = index + step;

            if (next <= MaxValue && countTree[next] < amount)
            {
                amount -= countTree[next];
                sum += sumTree[next];
                index = next;
            }
        }

        return sum + (long)amount * (index + 1);
    }
}