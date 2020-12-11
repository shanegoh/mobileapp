package com.example.activeandfit;

import java.io.Serializable;

//Serialization is the conversion of an object to a series of bytes,
//so that the object can be easily saved to persistent storage or streamed across a communication link
public class BookInfo implements Serializable {

    private String programme;
    private int numberOfSlot;
    private String date;
    private String time;
    private String day;
    private int img;
    private double price;
    private int discount;
    private double discountedPrice;
    private String endTime;

    public BookInfo(String programme, int numberOfSlot, String date, String time, String day, int img)
    {
        this.programme = programme;
        this.numberOfSlot = numberOfSlot;
        this.date = date;
        this.time = time;
        this.day = day;
        this.img = img;
    }

    public void setCost(double price, int discount, double discountedPrice)
    {
        this.price = price;
        this.discount = discount;
        this.discountedPrice = discountedPrice;
    }

    public void setEndTime(String endTime)
    {
        this.endTime = endTime;
    }

    public String getEndTime()
    {
        return endTime;
    }


    public double getPrice()
    {
        return price;
    }

    public int getDiscount()
    {
        return discount;
    }

    public double getDiscountedPrice()
    {
        return discountedPrice;
    }

    public int getImg() { return img; }

    public String getTime()
    {
        return time;
    }

    public int getNumberOfSlot()
    {
        return numberOfSlot;
    }

    public String getDay()
    {
        return day;
    }

    public String getProgramme() { return programme; }

    public String getDate()
    {
        return date;
    }

    public void setDate(String date)
    {
        this.date = date;
    }

    public void setSlot(int numberOfSlot)
    {
        this.numberOfSlot = numberOfSlot;
    }

    public void setDay(String day)
    {
        this.day = day;
    }

    public void setTime(String time)
    {
        this.time = time;
    }

    //Print info
    public String print()
    {
         String text ="     Gym Facility: " + getProgramme() + "\n" +
                "     Date: " + getDate() + "\n" +
                "     Start Time: " + getTime() + "\n" +
                "     Session(s): " + getNumberOfSlot() + "\n" +
                "     End Time: " + getEndTime() + "\n" +
                "     Total Amount: $" + getPrice();

         //If discount is present, display discount
        if(getPrice() >= 100)
        {
            text = text + "\n" + "     Discount: " + getDiscount() + "%\n" +
                    "     Discounted Amount: $" + (getPrice() * getDiscount()/100) + "\n" +
                    "     Final Price: $" + getDiscountedPrice();
        }
        return text;

    }

}
