//Mode	                  MHz   HVisible	HFront HSync  HBack	H Whole		  VVisable	VFront VSync  VBack	V Whole
//1280x720x60 (aka 720p)	74.25 1280	   72	    80	  216	   1648		      720	   3      5	     22	   750	

//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	80;//+23;  //32;  
parameter	H_SYNC_BACK	=	216;// +12;//190;
parameter	H_SYNC_ACT	=	1280;	
parameter	H_SYNC_FRONT=	72 ;//+10;//120;
parameter	H_SYNC_TOTAL=	1648 ;// +22;// 1622;
parameter	X_START		=	H_SYNC_CYC+ H_SYNC_BACK;



