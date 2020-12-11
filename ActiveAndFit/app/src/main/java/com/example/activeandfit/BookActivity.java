package com.example.activeandfit;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CalendarView;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import com.google.android.material.snackbar.Snackbar;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class BookActivity extends AppCompatActivity
{

    //Declare variables
    private String nextSlot = "";
    private int indexSlot = 0;
    private String[] everyHalf = {"00", "30"};
    private Boolean close;
    private List<String> times = new ArrayList<>();
    private List<String> updatedArray = new ArrayList<>();
    final int discountInPercentage = 10;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_book);

        //Declare final  ========================================//
        //sessionText EditText that reference to XML ID numberOfSession
        final EditText sessionText = (EditText) findViewById(R.id.numberOfSession);
        //Then, set spinTime as final.
        final Spinner spinTime = (Spinner) findViewById(R.id.spinner);
        //Get data from MainActivity
        final BookInfo info = (BookInfo)getIntent().getSerializableExtra("BookInfo");
        //To show day: EG: Monday
        final  SimpleDateFormat dayType = new SimpleDateFormat("EEEE");
        //When calendar view is clicked
        final CalendarView calendarView = (CalendarView) findViewById(R.id.calendarView);
        //To show date format EG: 20/10/2020
        final SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        //final "after" adapter for future date, with all time slots available
        final ArrayAdapter<String> after = new ArrayAdapter<String>(this, R.layout.spinner_item, times );
        //final "current" adapter for today's date, with upcoming earliest slot till closing
        final ArrayAdapter<String> current = new ArrayAdapter<String>(this, R.layout.spinner_item, updatedArray);
        final Button addCart = (Button)findViewById(R.id.addToCart);
        // ===========================================================//


        //Set title to show what user is booking
        setTitle(info.getProgramme());
        //Disable editing on sessionText(only when launch BookActivity)
        sessionText.setFocusable(false);
        //Generate time slots
        generateSession();
        //Check of nextSlot timing
        validateSlot();
        //Create a list of updatedArray
        updated_List(spinTime, current, info,  dayType);
        //Set default date
        info.setDate("0");



        //Listener
        calendarView.setOnDateChangeListener(new CalendarView.OnDateChangeListener()
        {
            @Override
            public void onSelectedDayChange(CalendarView view, int year, int month, int dayOfMonth)
            {

                //System date to string format
                String systemDate = sdf.format(new Date());
                //Value of month start from index 0 thus need plus 1
                String exactMonth = String.valueOf(month + 1);
                //Form selected date format
                String selectedDate = dayOfMonth + "/" + exactMonth + "/" + year;

                try
                {
                    //Convert to Date type for both present and selected date
                    Date present = sdf.parse(systemDate);
                    Date selected = sdf.parse(selectedDate);

                    //If user selected past dates, do..
                    if(selected.before(present))
                    {
                        //Disable editing for past dates
                        sessionText.setFocusable(false);
                        //Clear text
                        sessionText.setText("");
                        //Set list to null so user cannot select time slot
                        spinTime.setAdapter(null);
                        //set button unclickable
                        addCart.setEnabled(false);


                        //Error message
                        Snackbar error = Snackbar.make(view, "Please select a present or future date.", 2000);
                        error.show();
                    }
                    //If user selected today's date, do..
                    else if(selected.compareTo(present) == 0)
                    {
                        //If gym is still open
                        if(close == false)
                        {
                            //enable editing when user click present date
                            sessionText.setFocusableInTouchMode(true);
                            //Reduce slot list size from upcoming time slot to end.
                            spinTime.setAdapter(current);
                            //Set current spinner position to next slot for current timing for present date
                            spinTime.setSelection(current.getPosition(nextSlot));

                            //set button clickable
                            addCart.setEnabled(true);
                            //Set info's day detail
                            info.setDay(dayType.format(selected));
                            //Set date in info
                            info.setDate(selectedDate);
                            //Set info's time detail
                            info.setTime(spinTime.getSelectedItem().toString());

                            //Message
                            Toast.makeText(view.getContext(), "You have selected today", Toast.LENGTH_SHORT).show();

                        }
                        //If gym is closed
                        else
                        {
                            //set button clickable
                            addCart.setEnabled(false);
                            spinTime.setAdapter(null);
                            sessionText.setFocusable(false);
                            //Snackbar
                            Snackbar error = Snackbar.make(view, "There are no more sessions for today", 2000);
                            error.show();
                        }

                    }

                    //If user selected future date, do..
                    else
                    {
                        //enable editing when user click future date
                        sessionText.setFocusableInTouchMode(true);
                        //Set adapter to after(full list of time slot for future dates)
                        spinTime.setAdapter(after);
                        //Set default spinner position to first item(6am)
                        spinTime.setSelection(0);

                        //Set info object day detail
                        info.setDay(dayType.format(selected));
                        //Set date in info
                        info.setDate(selectedDate);
                        //Set info's time detail
                        info.setTime(spinTime.getSelectedItem().toString());

                        //Toast
                        Toast.makeText(view.getContext(), "You have selected " + selectedDate, Toast.LENGTH_SHORT).show();
                    }

                }
                //Need to catch ParseException
                catch (ParseException e)
                {
                    e.printStackTrace();
                }

            }
        });

        //TextChangeListener for sessionText (timeSlotView)
        sessionText.addTextChangedListener(new TextWatcher()
        {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2)
            {

            }

            @Override
            public void onTextChanged(CharSequence s, int i, int i1, int i2)
            {
                //When user delete slot, the user is unable to submit cart
                info.setSlot(0);
            }

            @Override
            public void afterTextChanged(Editable editable)
            {
                //Check constraint
                violationCheck(sessionText, spinTime, info);
            }
        });

        //On select listener for spinner
        spinTime.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener()
        {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id)
            {
                //Clear slot timing when time changed
                sessionText.setText("");
                //Check constraint
                violationCheck(sessionText, spinTime, info);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent)
            {

            }
        });

        addCart.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {

                final Intent intent = new Intent(BookActivity.this, PaymentActivity.class);
                String message = "";

                if(info.getDate() == "0")
                {
                    message = "Please select a date";
                }
                else if(info.getTime() == "0")
                {
                    message = "Please select a time";
                }
                else if(info.getNumberOfSlot() == 0)
                {
                    message = "Please select number of session(s)";
                }
                else {

                    //Use this pChecker object of price to calculate price
                    Price pChecker = new Price();

                    //Original Price
                    double price = pChecker.calculatePrice(info.getProgramme(), info.getDay(),
                            info.getTime(), info.getNumberOfSlot(),
                            getCalculation(info.getTime(), info.getNumberOfSlot()));

                    //On click, set the cost and update time
                    info.setCost(price, discountInPercentage, pChecker.calDiscountPrice(price));
                    info.setEndTime(calculateTime(info.getTime(), info.getNumberOfSlot()));
                    //Pass values to next activity
                    intent.putExtra("BookInfo", info);
                    startActivity(intent);
                }
                //Show error if any
                Snackbar error = Snackbar.make(v, message, 2000);
                error.show();

            }
        });

    }

    //Calculate end time with start and session hours
    private static String calculateTime(String timeSlot, int hour)
    {
        int time = Integer.valueOf(String.valueOf(timeSlot.charAt(0)
                + String.valueOf(timeSlot.charAt(1))));
        String setHour = "";

        //If time is less than 10 am, set extra zero infront
        if(time + hour < 10)
        {
            setHour = "0" + String.valueOf(time + hour);
        }
        else
        {
            setHour = String.valueOf(time + hour);
        }

        return setHour + ":" + String.valueOf(timeSlot.charAt(3)) + String.valueOf(timeSlot.charAt(4));

    }

    public static String getCalculation(String timeSlot, int hour)
    {
        return calculateTime(timeSlot, hour);
    }


    //Method to check booking constraint
    private void violationCheck(EditText et, Spinner spinTime, BookInfo info)
    {

        try
        {
            //Get number of book hours
            int numberOfHour = Integer.valueOf(et.getText().toString());

            //Get user selected time slot from spinner
            String selectedSlot = spinTime.getSelectedItem().toString();
            String first = String.valueOf(selectedSlot.charAt(0));
            String second = String.valueOf(selectedSlot.charAt(1));
            int third = Integer.valueOf(String.valueOf(selectedSlot.charAt(3)));
            int h = Integer.valueOf(first + second);

            //If selected slot + number of slots/hours is more than 10pm, prompt error
            if(h + numberOfHour == 22 && third == 3 || h + numberOfHour > 22)
            {
                //Show error
                et.setError("You cannot book slots over 10pm");
            }
            else
            {
                //update time and number of selected session/slot
                info.setTime(selectedSlot);
                info.setSlot(numberOfHour);
                String programme = info.getProgramme();
                String date = info.getDate();
            }

        }
        //Catch empty value as digits are set to only 1 - 9
        catch(NumberFormatException e)
        {
            //Show error
            et.setError("Please enter a value");

        }
    }

    private void generateSession()
    {
        int max = 2;
        //Add time slot
        for (int i = 6; i < 22; i++)
        {
            //Set to up to 10pm
            if(i == 21)
            {
                max = 1;
            }
            for (int j = 0; j < max; j++)
            {
                //Before 10 am, add zero
                if( i < 10)
                {
                    String time = "0" + i + ":" + everyHalf[j];
                    times.add(time);
                }
                else
                {

                    String time = i + ":" + everyHalf[j];
                    times.add(time);
                }
            }
        }
    }

    private void validateSlot()
    {
        //find current system time
        String currentTime = new SimpleDateFormat("HH:mm", Locale.getDefault()).format(new Date());
        //hour needed to validate upcoming time slot
        String hour = String.valueOf(currentTime.charAt(0)) + String.valueOf(currentTime.charAt(1));

        //If its 12 hour clock and below 10 am, set it so 24h time
        if(String.valueOf(hour.charAt(1)).equals(":"))
        {
            hour = "0" + hour;
        }

        //minute needed to validate upcoming time slot
        int minute = Integer.valueOf(String.valueOf(currentTime.charAt(3)) + String.valueOf(currentTime.charAt(4)));
        //If minute is between 0 - 30
        if (minute >= 00 && minute < 30)
        {
            nextSlot = hour + ":" + "30";
        }
        //If is more than 30min, go to next hour slot
        else
        {
            int hours = Integer.valueOf(hour) + 1;
            if(hours < 10)
            {
                String addZero =  "0" + String.valueOf(hours);
                nextSlot = addZero + ":" + "00";
            }
            else{
                nextSlot = String.valueOf(hours) + ":" + "00";
            }

            if(hours >= 0 && hours < 6)
            {
                nextSlot = "06:00";
            }
        }


        int midNight = Integer.valueOf(hour);
        //If after 00:00 to before 06:00, set next slot to 06:00
        if(midNight >= 00 && midNight < 06)
        {
            nextSlot = "06:00";
        }

    }

    private void updated_List(Spinner spinTime, ArrayAdapter current, BookInfo info, SimpleDateFormat dayType)
    {
        int checkHour = Integer.valueOf(String.valueOf(nextSlot.charAt(0)) + String.valueOf(nextSlot.charAt(1)));

        //if next slot is 9pm or before , able to book. Else its close
        if(checkHour <= 21)
        {
            //Boolean set default gym status open
            close = false;
            //If its 12 hour clock and below 10 am, set it so 24h time


            //Look for upcoming time slot
            for (int i = 0; i < times.size(); i++)
            {
                if (times.get(i).equals(nextSlot))
                {
                    indexSlot = i;
                }
            }

            //Set all upcoming time slot to updatedArray
            for (int j = indexSlot; j < times.size(); j++)
            {
                updatedArray.add(times.get(j));
            }
            //spinTime spinner set adapter to today's upcoming slot(Removing past sessions)
            spinTime.setAdapter(current);
            //Set system current day of the week
            info.setDay(dayType.format(new Date()));
            //Set next time slot as default
            info.setTime(spinTime.getSelectedItem().toString());

        }
        else
        {
            //Set boolean close to true
            close = true;
            //Set adapter to null(Nothing inside spinner
            spinTime.setAdapter(null);
        }
    }
}