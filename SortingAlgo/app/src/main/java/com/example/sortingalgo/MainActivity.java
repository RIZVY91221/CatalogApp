package com.example.sortingalgo;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private TextView textView;
    private EditText editText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        editText = findViewById(R.id.inputNumEdit);
        textView = findViewById(R.id.textView);
    }

    public void SortButton(View view){
        String[] stringsNumber = editText.getText().toString().split(",");
        Integer[] integersNumber = new Integer[stringsNumber.length];

        for (int i = 0; i < stringsNumber.length; i++){
            integersNumber[i] = Integer.parseInt(stringsNumber[i]); //Converting from String Array to Integer Array
        }
        Integer[] sortedNumbers = QuickSort(integersNumber);
        textView.setText(Arrays.toString(sortedNumbers));
    }

    private Integer[] QuickSort(Integer[] numbers){
        int n = numbers.length;
        if(n < 2){
            return numbers;
        }

        Integer[] sortedNumber = new Integer[n];
        List<Integer> leftNumbers = new ArrayList<Integer>();
        List<Integer>rightNumbers = new ArrayList<Integer>();

        for(int i=0;i < n-1;i++){
            if ((numbers[i] <numbers[n-1])){
                leftNumbers.add(numbers[i]);
            }else{
                rightNumbers.add(numbers[i]);
            }
        }
        Integer[] leftNumberSorted = QuickSort(leftNumbers.toArray(new Integer[leftNumbers.size()]));
        Integer[] rightNumberSorted = QuickSort(rightNumbers.toArray(new Integer[rightNumbers.size()]));
        int k;
        for (k=0; k < leftNumberSorted.length;k++){
            sortedNumber[k]=leftNumberSorted[k];
        }
        sortedNumber[k] = numbers[n-1];

        for (int j=0; j < rightNumberSorted.length; j++){
            sortedNumber[++k] = rightNumberSorted[j];
        }
        return sortedNumber;
    }
}
