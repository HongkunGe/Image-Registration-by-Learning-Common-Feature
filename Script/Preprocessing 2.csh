


SliceNum=198
#registration 
iterRavens=35
for a in 1 2 4 5 7 9 10 11
do
cd NORMAL0${a}
aa=NORMAL0${a}-ls-corrected
bb=NORMAL0${a}-ls-corrected-later

echo "hammer registration"
# transform the format to byte
short2byte $aa.img $aa-byte.img 256 256 ${SliceNum} 0
makeavwheader $aa-byte.hdr -d256,256,${SliceNum} -r1,1,1 -tCHAR
short2byte $bb.img $bb-byte.img 256 256 ${SliceNum} 0
makeavwheader $bb-byte.hdr -d256,256,${SliceNum} -r1,1,1 -tCHAR
HAMMER_InputMdlSubj.V2.5-SBIA.pl -M $bb-byte.img -S ${aa}-byte.img -O $aa-byte.img -d d1 -i $iterRavens -X256,256,${SliceNum} -x256,256,${SliceNum} -V1,1,1 -v1,1,1 -T   > nouse &
cd ..
done

#denoising
for a in {1..14}
do  
cd NORMAL0${a}
fDenoise.csh NORMAL0${a}_T2.hdr short
fDenoise.csh NORMAL0${a}_T1.hdr short
echo $a
cd ..
done


SliceNum=198
#registration 
iterRavens=35
for a in 1 2 4 5 7 9 10 11
do
cd NORMAL0${a}
PerformDeformationOnImgUsingVectorField_ShortImg  d1.Field.1.img.Mdl2Subj NORMAL0${a}_cbq-denoise.img NORMAL0${a}_cbq-denoise-warped.img 
makeAVWHeader  NORMAL0${a}_cbq-denoise-warped.hdr -d256,256,${SliceNum} -r1,1,1 -tSHORT
cd ..
done

# flirt to the NORMAL01 subject
SliceNum=198
#registration 
iterRavens=35
for a in 2 4 5 7 9 10 11
do
cd NORMAL0${a}
echo $a
flirt -in NORMAL0${a}_cbq-later.hdr -ref ../NORMAL01/NORMAL01_cbq-later.hdr -out NORMAL0${a}_cbq-later-flirt.hdr -dof 6 -omat acpc.mat &
cd ..
done



for a in 2 4 5 7 9 10 11
do
cd NORMAL0${a}
echo $a
flirt -in NORMAL0${a}_cbq-denoise-warped.hdr -ref ../NORMAL01/NORMAL01_cbq-later.hdr  -applyxfm -init acpc.mat -out NORMAL0${a}_cbq-denoise-warped-flirt.hdr  -interp trilinear
flirt -in NORMAL0${a}-ls-corrected-later.hdr -ref ../NORMAL01/NORMAL01_cbq-later.hdr  -applyxfm -init acpc.mat -out NORMAL0${a}-ls-corrected-later-flirt.hdr  -interp nearestneighbour
cd ..
done



##########here
cd NORMAL01

 ScalarOp  NORMAL01_cbq-later.hdr NORMAL01_cbq-later-h.hdr -h  NORMAL01_cbq-denoise-warped.hdr




#set the intensities in a same range
for a in 2 4 5 7 9 10 11
do
cd NORMAL0${a}
echo $a
ScalarOp  NORMAL0${a}_cbq-denoise-warped-flirt.hdr   NORMAL0${a}_cbq-denoise-warped-flirt-h.hdr -h ../NORMAL01/NORMAL01_cbq-denoise-warped.hdr
ScalarOp  NORMAL0${a}_cbq-later-flirt.hdr NORMAL0${a}_cbq-later-flirt-h.hdr -h ../NORMAL01/NORMAL01_cbq-later-h.hdr 
cd ..
done

for a in 2 4 5 7 9 10 11
do
cd NORMAL0${a}
echo $a
ScalarOp  NORMAL0${a}_cbq-denoise-warped-flirt.hdr   NORMAL0${a}_cbq-denoise-warped-flirt-h2.hdr -h ../NORMAL01/NORMAL01_cbq-denoise-warped.hdr
ScalarOp  NORMAL0${a}_cbq-later-flirt.hdr NORMAL0${a}_cbq-later-flirt-h2.hdr -h ../NORMAL01/NORMAL01_cbq-later.hdr 
cd ..
done


#Demons
#for a in 2 4 5 7 9 10 11
#do
#cd NORMAL0${a}
#cp ../NORMAL01/ref.??? ./
#fDemonsRegistration.csh NORMAL0${a}_cbq-denoise-warped-flirt-h.hdr ref.hdr
#PerformDeformationOnImgUsingVectorField_ShortImg Field.1.img.Subj2Mdl NORMAL0${a}_cbq-denoise-warped-flirt-h.img NORMAL0${a}_cbq-denoise-warped-flirt-h-demons.img 
#PerformDeformationOnImgUsingVectorField_ShortImg Field.1.img.Subj2Mdl NORMAL0${a}_cbq-later-flirt-h.img NORMAL0${a}_cbq-later-flirt-h-demons.img
#PerformDeformationOnImgUsingVectorField_ShortImg Field.1.img.Subj2Mdl NORMAL0${a}-ls-corrected-later-flirt.img NORMAL0${a}-ls-corrected-later-flirt-demons.img
#cp ref.hdr NORMAL0${a}_cbq-denoise-warped-flirt-h-demons.hdr
#cp ref.hdr NORMAL0${a}_cbq-later-flirt-h-demons.hdr
#cp ref.hdr NORMAL0${a}-ls-corrected-later-flirt-demons.hdr 
#cd ..
#echo $a
#done
#
#
#







