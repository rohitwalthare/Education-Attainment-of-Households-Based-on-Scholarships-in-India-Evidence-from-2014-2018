*************   Install packages and set filepath   *************
pwd
clear all

* Install necessary packages (for your reference)
*ssc install schemepack, replace
*ssc install binscatter, replace
*ssc install estout, replace
*ssc install balancetable, replace

* Set scheme for graphs to make them look nice
set scheme white_tableau

* Set font
graph set window fontface "Fira Sans" // my favorite font
*graph set window fontface "Arial"
*graph set window fontface default

display c(hostname)

if "`c(hostname)'" == "VD-LIB-STATA-5" {
	global root		"Z:\Dropbox\05 - Vanderbilt\2022 - Fall\Seminar in Research\Research Project\7910_project-main"
	di				"You are on VU Virtual Desktop"
}

if "`c(hostname)'" == "Shadow" {
	global root  	"D:\7910\7910_project"
	di 				"You are on Rohit's computer"
}

cd "$root"

*************   Clean the 71st round  *************

use "$root\data\raw\HSCES71\B4.dta", clear 			//310827 x 
sort HH_ID
keep HH_ID round sector state_district age sex gen_edu psrl_no					 
save "$root\data\clean\HSCES71\dataset4.dta", replace

use "$root\data\raw\HSCES71\B3.dta", clear 			//65926 x 3
sort HH_ID
keep HH_ID religion social_grp 			 
save "$root\data\clean\HSCES71\dataset3.dta", replace

use "$root\data\raw\HSCES71\B5.dta", clear 			//93513 x 9
sort HH_ID
keep HH_ID psrl_no inst_type edu_free scholarship schlor_type textbooks stationery midday_meal 			 
save "$root\data\clean\HSCES71\dataset5.dta", replace

*************   Merge the datasets   *************

* merge dataset4 and dataset3
use "$root\data\clean\HSCES71\dataset4.dta"
merge m:1 HH_ID using "$root\data\clean\HSCES71\dataset3.dta"
gen IID = HH_ID + psrl_no
sort IID
drop _merge
save "$root\data\clean\HSCES71\merged_data_3&4.dta", replace
use "$root\data\clean\HSCES71\merged_data_3&4.dta"

*merge merged_data_3&4 and dataset5
use "$root\data\clean\HSCES71\dataset5.dta"
gen IID = HH_ID + psrl_no
sort IID
merge 1:1 IID using "$root\data\clean\HSCES71\merged_data_3&4.dta"
save "$root\data\clean\HSCES71\merged_data71.dta", replace
use "$root\data\clean\HSCES71\merged_data71.dta"
sort IID

*************   Drop records with no education data   *************

keep if _merge == 3
drop _merge
destring, replace
sort HH_ID
save "$root\data\clean\HSCES71\merged_data71.dta", replace
use "$root\data\clean\HSCES71\merged_data71.dta"

cd "$root\data\clean"
save cleaned71, replace

*************   Clean the 75th round  *************

clear all

use "$root\data\raw\HSCES75\B4.dta", clear 			//310827 x 
sort HHID
keep HHID Round Sector StateDistrict Age Gender Edu_level_general Per_serialno					 
save "$root\data\clean\HSCES75\dataset4.dta", replace

use "$root\data\raw\HSCES75\B3.dta", clear 			//65926 x 3
sort HHID
keep HHID Religion Social_group 			 
save "$root\data\clean\HSCES75\dataset3.dta", replace

use "$root\data\raw\HSCES75\B5.dta", clear 			//93513 x 9
sort HHID
keep HHID Per_serialno Institution_type Free_education Scholarship_stipend Reimbursement_type Whether_free_textbooks Whether_free_stationary Midday_meal_tiffin 			 
save "$root\data\clean\HSCES75\dataset5.dta", replace

*************   Merge the datasets   *************

* merge dataset4 and dataset3
use "$root\data\clean\HSCES75\dataset4.dta"
merge m:1 HHID using "$root\data\clean\HSCES75\dataset3.dta"
gen IID = HHID + Per_serialno
sort IID
drop _merge
save "$root\data\clean\HSCES75\merged_data_3&4.dta", replace
use "$root\data\clean\HSCES75\merged_data_3&4.dta"

*merge merged_data_3&4 and dataset5
use "$root\data\clean\HSCES75\dataset5.dta"
gen IID = HHID + Per_serialno
sort IID
merge 1:1 IID using "$root\data\clean\HSCES75\merged_data_3&4.dta"
save "$root\data\clean\HSCES75\merged_data75.dta", replace
use "$root\data\clean\HSCES75\merged_data75.dta"
sort IID

*************   Drop records with no education data   *************

keep if _merge == 3
drop _merge
destring, replace
sort HHID
save "$root\data\clean\HSCES75\merged_data75.dta", replace
use "$root\data\clean\HSCES75\merged_data75.dta"

*************   Rename 75th round variables to marth 71st round   *************

order HHID IID Per_serialno  StateDistrict Round Age Gender Edu_level_general Free_education Scholarship_stipend Reimbursement_type Institution_type Religion Social_group Sector  Whether_free_stationary Whether_free_textbooks Midday_meal_tiffin

rename HHID HH_ID
rename Round round
rename Sector sector
rename Religion religion
rename Social_group social_grp
rename Gender sex
rename Edu_level_general gen_edu
rename Institution_type inst_type
rename Free_education edu_free
rename Scholarship_stipend scholarship
rename Reimbursement_type schlor_type 
rename Whether_free_textbooks textbooks
rename Whether_free_stationary stationery	
rename Midday_meal_tiffin midday_meal
rename StateDistrict state_district
rename Per_serialno psrl_no
rename Age age

* renaming the labels level 
label define Gender 1 "Male" 2 "Female" 3 "others"
label values sex Gender

label define Free_education 1 "Yes" 2 "No"
label values edu_free Free_education

label define Scholarship_stipend 1 "Yes" 2 "No"
label values scholarship Scholarship_stipend

label define Reimbursement_type 1 "ST" 2 "SC" 3 "OBC" 4 "Handicapped" 5 "Merit" 6 "Financially weak" 7 "Others"
label values schlor_type Reimbursement_type

label define Institution_type 1 "Government" 2 "Private aided" 3 "Private un-aided" 4 "Not Known"
label values inst_type Institution_type

label define Religion 1 "Hinduism" 2 "Islam" 3 "Christianity" 4 "Sikhism" 5 "Jainism" 6 "Buddhism" 7 "Zoroastrianism" 9 "others" 
label values religion Religion

label define Social_group 1 "scheduled tribe" 2 "scheduled caste" 3 "other backward class" 4 "others"
label values social_grp Social_group

label define Sector 1 "Rural" 2 "Urban"
label values sector Sector

label define Whether_free_stationary 1 "All free" 2 "Some free" 3 "All subsidised" 4 "Some subsidised" 5 "Some free and some subsideised" 6 "No"
label values stationery Whether_free_stationary

label define Whether_free_textbooks 1 "All free" 2 "Some free" 3 "All subsidised" 4 "Some subsidised" 5 "Some free and some subsideised" 6 "No"
label values textbooks Whether_free_textbooks

label define Midday_meal_tiffin	1 "Yes" 2 "No" 
label values midday_meal Midday_meal_tiffin

cd "$root\data\clean"
save cleaned75label,replace

*************   Append rounds 75 and 71   *************

clear all

use "$root\data\clean\cleaned71"
append using "$root\data\clean\cleaned75label", generate (new_obs) nolabel nonotes
drop new_obs 
order IID HH_ID psrl_no round state_district age sex religion social_grp gen_edu
save "$root\data\clean\append7175", replace

use "$root\data\clean\append7175"
duplicates drop IID, force

*************   Generate new scholarship variable   *************

bysort state_district round: gen district_samplesize = _N
bysort state_district round: egen scholarship_count = total(scholarship==1) 
gen scholarship_ratio = scholarship_count/district_samplesize
order state_district round district_samplesize scholarship scholarship_count scholarship_ratio

*************   Drop individuals outside of age limits   *************

drop if age >18 | age <5

gen rounddummy = 0 
replace rounddummy = 1 if round == 75

*************   Regression OLS   *************


global control rounddummy age i.sex i.religion ib4.social_grp i.inst_type ib2.edu_free ib6.textbooks ib6.stationery ib2.midday_meal

reg gen_edu scholarship_ratio $control, cl(state_district)

eststo reg1
esttab reg1 using "$root\results\tables\Reg1.tex", ///
		replace b(2) se(3) label ///
				ar2 star(* 0.10 ** 0.05 *** 0.01) ///
				mtitle("Years of education attained")

				
*************   Regression DID   *************

gen Interaction = rounddummy*scholarship_ratio
reg gen_edu Interaction scholarship_ratio $control, cl(state_district)

eststo reg2
esttab reg2 using "$root\results\tables\Reg2.tex", ///
		replace b(2) se(3) label ///
				ar2 star(* 0.10 ** 0.05 *** 0.01) ///
				mtitle("Years of education attained")
				
	











