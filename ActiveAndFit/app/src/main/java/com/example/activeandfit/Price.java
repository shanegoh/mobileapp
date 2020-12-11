package com.example.activeandfit;

public class Price
{
    //Declare final variable
    final double DISCOUNT = 0.1;

    public Price()
    {

    }

    //Calculate Price
    protected double calculatePrice(String programme, String dayOfWeek, String hour, int sessions, String end)
    {
        //Start Time
        int start = Integer.valueOf(String.valueOf(hour.charAt(0)) + String.valueOf(hour.charAt(1)));
        //to get minutes
        String c = String.valueOf(hour.charAt(3));

        //End Time
        int endTime = Integer.valueOf((end.charAt(0)) + String.valueOf(end.charAt(1)));

        //variables
        double price = 0;
        double peakPrice = 0;
        double nonPeak = 0;


        switch (programme)
        {
            //25 for peak, 20 for non peak
            case "Pool":
                peakPrice = 25;
                nonPeak = 20;
                break;
            //35 for peak, 30 for non peak
            case "Tennis Court":
            case "Yoga Room":
            case "Squash Court":
                peakPrice = 35;
                nonPeak = 30;
                break;
            //45 for peak, 40 for non peak
            case "Functional Fitness":
                peakPrice = 45;
                nonPeak = 40;
                break;

        }
        //Check price, get back price
        price = priceChecker(dayOfWeek, start, endTime, price, sessions, c, peakPrice, nonPeak);

        //return price
        return price;
    }

    //Check price based on peak or non peak
    protected double priceChecker(String dayOfWeek, int start, int endTime, double price, int sessions, String c, double pp, double npp)
    {

        //Monday - Friday
        if(!dayOfWeek.equals("Saturday") && !dayOfWeek.equals("Sunday"))
        {
            //Peak
            if(start >= 18  && endTime <= 22)
            {
                price =  price + (sessions * pp);
            }
            //Non Peak
            else if(start >= 6 && endTime < 18)
            {
                price = price + (sessions * npp);
            }
            //Non Peak with Peak
            else if(start < 18 && endTime <= 22)
            {
                //Loop based on number of sessions
                for(int i = 0; i < sessions; i ++)
                {
                    //Max is to 17:30
                    if (start < 17 && c.equals("3"))
                    {
                        start++;
                        price = price + npp;
                    }
                    //for 17:30
                    else if (start == 17 && c.equals("3"))
                    {
                        start++;
                        double offWithPeak = (0.5 * npp) + (0.5 * pp);
                        price = price + offWithPeak;
                    }
                    //Less than 18:00, non peak
                    else if (start < 18 && c.equals("0"))
                    {
                        start++;
                        price = price + npp;
                    }
                    //After 18:00 peak price
                    else if (start >= 18 && (c.equals("0") || c.equals("3")))
                    {
                        start++;
                        price = price + pp;
                    }
                }

            }

        }
        //Saturday and Sunday
        else
        {
            //Peak hour till 11.30
            if(start >= 6 && endTime < 12)
            {
                price = price + (sessions * pp);
            }
            //Non peak 12 - 22
            else if(start >= 12 && endTime <= 22)
            {
                price = price + (sessions * npp);
            }
            //Peak with Non Peak
            else if(start < 12 && endTime <= 22)
            {
                //Loop based on number of sessions
                for(int i = 0; i < sessions; i ++)
                {
                    //Time slot below 11:30
                    if (start < 11 && c.equals("3"))
                    {
                        start++;
                        price = price + pp;
                    }
                    //for between 11:30 and 12:30
                    else if (start == 11 && c.equals("3"))
                    {
                        start++;
                        double offWithPeak = (0.5 * npp) + (0.5 * pp);
                        price = price + offWithPeak;
                    }
                    //Less than 12:00, peak price
                    else if (start < 12 && c.equals("0"))
                    {
                        start++;
                        price = price + pp;
                    }
                    //After 12:00 non peak price
                    else if (start >= 12 && (c.equals("0") || c.equals("3")))
                    {
                        start++;
                        price = price + npp;
                    }
                }
            }
        }

        return price;
    }

    //Calculating discounted price
    protected double calDiscountPrice(double price)
    {
        boolean discountOrNot;
        if(price > 100)
        {
            price = price - (price * DISCOUNT);
        }
        return price;
    }
}

