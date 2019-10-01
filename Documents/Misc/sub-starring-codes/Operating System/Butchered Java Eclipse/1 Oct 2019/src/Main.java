import java.util.ArrayList;
import java.util.Iterator;
import java.util.Scanner;
import java.util.Vector;

/**
 * 
 */

/**
 * @author JOELwindows7
 *
 */
public class Main {
	
	public Main() {
		// TODO Auto-generated constructor stub
//		System.out.println("Hello");
//		System.out.print("Hello\n");
//		System.out.print("World");
		// Block text, Ctrl + /
		
//		int umur = 10;
//		float ipk = 3.5f;
//		double luasPersegi = 102.456;
//		boolean flag = true;
//		String nama = "Alicia";
//		char alfabet = 'A';
//		
//		//sysout, ctrl + Space
//		System.out.println("Nama adalah " + nama 
//				+ " dan ipknya " + ipk);
//		
//		float nilaiKoma = 3.5f;
//		int nilai = (int)nilaiKoma;
//		
//		System.out.println(nilai);
//		
//		int angka = 10;
//		String str = Integer.toString(angka); // "10"
//		System.out.println(str);
		
//		final int angka = 10;
		//angka = 20; //error, angka must blank
		
//		int perkalian = angka * angka; //100
//		int pertambahan = angka + angka; //20
//		int pengurangan = 20 - angka; //10
//		int pembagian = angka / angka; //1
//		int hasilBagi = angka % 3;
////		System.out.println(perkalian);
////		System.out.println(pertambahan);
////		System.out.println(pengurangan);
//		System.out.println(pembagian);
//		System.out.println(hasilBagi);
		
//		int nilai = 69;
//		if(nilai > 70){
//			System.out.println("Lulus");
//		} else if(nilai == 69) {
//			System.out.println("Sedikit Lagi");
//		} else {
//			System.out.println("Tidak Lulus");
//		}
//		
//		for(int x = 1; x<=10;x+=2){
//			System.out.print(x + " ");
//		}
//		
//		int y = 1;
//		while(y<=10){
//			System.out.print(y + " ");
//			y++;
//		}
//		
//		System.out.println();
//		int z = 1;
//		do {
//			System.out.print(z + " ");
//			z++;
//		} while (z <= 10);
//		
//		String listNama[] = {"Dani", "Leo","Billy"};
//		System.out.println(listNama[0]);
//		for (int i = 0; i < listNama.length; i++) {
//			System.out.println(listNama[i]);
//		}
//		
//		int listAngka[] = {1,2,10,4};
		
//		cetak(18,31);
//		
//		Vector<String> listMerk = new Vector<>();
//		listMerk.add("Toyota"); //0
//		listMerk.add("Yonex"); //1
//		
//		//Difference from array
//		/*
//		 * array is static declare. once declare, cannot add more in execution.
//		 * Vector is dynamic. can add more as necessary.
//		 * linked list similarity
//		 */
//		
//		for (int i = 0; i < listMerk.size(); i++) {
//			System.out.println(listMerk.get(i));
//		}
//		
//		for (String string : listMerk) { //for each
//			//DataType TampungVariableTemp: inWhatVariable
//			System.out.println(string);
//		}
//		
//		listMerk.set(0, "Honda");
//		
//		for (String temp : listMerk) { //for each
//			//DataType TampungVariableTemp: inWhatVariable
//			System.out.println(temp);
//		}
//		
//		ArrayList<String> listBrando = new ArrayList<>();
//		listBrando.add("Drop");
		
		Scanner scan = new Scanner(System.in);
		int pilihan = 0;
		System.out.print("Input pilihan: ");
		
		//handle error
		try{
			pilihan = scan.nextInt();
		}catch(Exception e){
			pilihan = 0;
			e.printStackTrace();
		}
		
		scan.nextLine(); //without this, the next scan will skippy
		
		System.out.println("Hasil Pilihan : " + pilihan);
		
		String nama = "";
		System.out.print("Input nama: ");
		nama = scan.nextLine();
		
		System.out.println("Nama: " + nama);
	}
	
	public void cetak(){
		System.out.println("Hello world");
	}
	
	public void cetak(int a , int b ){
		
		System.out.println("Pertambahan: " + (a+b));
	}

	/**
	 * @param args WellTest Sapphire
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		new Main(); //call constructor first!
	}

}
