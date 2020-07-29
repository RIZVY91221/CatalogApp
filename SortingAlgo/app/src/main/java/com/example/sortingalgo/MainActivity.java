package com.example.sortingalgo;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.github.mikephil.charting.charts.BarChart;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.utils.ColorTemplate;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {


    private TextView textView;
    private EditText editText;
    private int i = 0;
    private List<Integer[]> sortedList ;
    private RecyclerView recyclerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        sortedList = new ArrayList<>();

        LinearLayoutManager layoutManager = new LinearLayoutManager(this);

        recyclerView = findViewById(R.id.rv_list);

        recyclerView.setHasFixedSize(true);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setItemAnimator(new DefaultItemAnimator());


        editText = findViewById(R.id.inputNumEdit);
        //textView = findViewById(R.id.textView);
    }

    public void SortButton(View view){
        String[] stringsNumber = editText.getText().toString().split(",");
        Integer[] integersNumber = new Integer[stringsNumber.length];


        for (int i = 0; i < stringsNumber.length; i++){
            integersNumber[i] = Integer.parseInt(stringsNumber[i]); //Converting from String Array to Integer Array
        }
        sortedList.add(integersNumber);
        Integer[] sortedNumbers = QuickSort(integersNumber);
        //textView.setText(Arrays.toString(sortedNumbers));


        ListAdapter adapter = new ListAdapter(this,sortedList);
        recyclerView.setAdapter(adapter);
    }

    private Integer[] QuickSort(Integer[] numbers){
        Log.d("calling",(i++)+"");
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
        sortedList.add(sortedNumber);

        return sortedNumber;
    }
}
