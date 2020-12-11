package com.example.activeandfit;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.util.ArrayList;

public class CompleteActivity extends AppCompatActivity
{
    private String text = "";
    private String newText = "";

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_complete);
        setTitle("Complete!");
        ArrayList<BookInfo> dataList = (ArrayList<BookInfo>) getIntent().getSerializableExtra("dataList");

        //showDetail reference to showDetail TextView
        TextView showDetail = (TextView) findViewById(R.id.showDetail);
        //Import scrollingMovement
        showDetail.setMovementMethod(new ScrollingMovementMethod());

        //i for printing number
        int i = 0;
        //Loop for printing multiple bookings
        for( BookInfo info : dataList)
        {
             ++i;
             text = String.format("(%d) \n%s\n", i, info.print());
             newText = newText + "\n" + text;
        }
        //Print all booking details
        showDetail.setText(newText);


        //On Click "OK"
        Button finishButton = (Button) findViewById(R.id.finishButton);
        finishButton.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View view)
            {
                //Intent to MainActivity(Main Page)
                Intent intent = new Intent(CompleteActivity.this, MainActivity.class);
                //added the flag so it doesn't add a new instance to the stack
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(intent);
            }
        });
    }

    //Disable user to go back to previous page
    @Override
    public void onBackPressed() { return; }

}
