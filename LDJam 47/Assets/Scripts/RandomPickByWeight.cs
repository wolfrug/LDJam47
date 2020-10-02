using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public static class RandomPickByWeight {
    /* from:https://stackoverflow.com/questions/56692/random-weighted-choice
    Dictionary<string, float> foo = new Dictionary<string, float>();
        foo.Add("Item 25% 1", 0.5f);
        foo.Add("Item 25% 2", 0.5f);
        foo.Add("Item 50%", 1f);
        for(int i = 0; i < 10; i++)
            Console.WriteLine(this, "Item Chosen {0}", foo.RandomElementByWeight(e => e.Value));
    */
    public static T RandomElementByWeight<T> (this IEnumerable<T> sequence, Func<T, float> weightSelector, int randomSeed) {
        float totalWeight = sequence.Sum (weightSelector);
        // The weight we are after...
        double itemWeightIndex = UnityEngine.Random.Range (0f, 1f) * totalWeight;
        float currentWeightIndex = 0;

        foreach (var item in from weightedItem in sequence select new { Value = weightedItem, Weight = weightSelector (weightedItem) }) {
            currentWeightIndex += item.Weight;

            // If we've hit or passed the weight we are after for this item then it's the one we want....
            if (currentWeightIndex >= itemWeightIndex)
                return item.Value;

        }

        return default (T);

    }
}