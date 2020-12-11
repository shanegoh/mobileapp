package com.example.activeandfit;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.Serializable;
import java.util.ArrayList;

public class PaymentActivity extends AppCompatActivity
{
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);
        //Set title
        setTitle("Payment");

        //final
        final BookInfo info = (BookInfo)getIntent().getSerializableExtra("BookInfo");

        //ImageView
        ImageView act = (ImageView) findViewById(R.id.activityImage);
        //set image
        act.setImageResource(info.getImg());

        //TextView
        TextView receiptView = (TextView) findViewById(R.id.receiptView);
        //display text
        receiptView.setText(info.print());

        //Proceed button
        Button proceedButton = (Button)findViewById(R.id.PROCEED);
        proceedButton.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                //Alert pop up dialog
                AlertDialog.Builder dialog=new AlertDialog.Builder(v.getContext());
                dialog.setTitle("Do you wish to continue?");
                dialog.setMessage("You can't make changes once submitted\n" +
                        "(You can go back to make changes)");
                dialog.setPositiveButton("YES",
                        new DialogInterface.OnClickListener()
                        {
                            public void onClick(DialogInterface dialog, int which)
                            {
                                //New intent to CompleteActivity
                                Intent intent = new Intent(PaymentActivity.this, CompleteActivity.class);
                                //get ArrayList instance
                                ArrayList<BookInfo> dataList = DataHolder.getInstance().dataList;
                                //add object to array
                                dataList.add(info);
                                //Pass data to next activity
                                intent.putExtra("dataList", dataList);
                                //start activity
                                startActivity(intent);
                                finish();
                            }
                        });
                dialog.setNegativeButton("Bring me back!",new DialogInterface.OnClickListener()
                {
                    @Override
                    public void onClick(DialogInterface dialog, int which)
                    {
                        //Return to previous activity
                        onBackPressed();
                    }
                });
                //create dialog
                AlertDialog alertDialog = dialog.create();
                //show dialog
                alertDialog.show();

            }

        });



    }

}