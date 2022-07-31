# DocumentationTool
Functions revolving around docu-struct and docu-file

  TEST
## Main features:
    struct/file (docu-struct/file) contains all relevant info (see below)
    version tree
    lots of opportunities for documentation
    models and data can be added without changing the code for fitting.
    

## Steps for setting up a new model fitting:

1. Download data, write interface, add data selector to mat-file using createAllSelectorsFile.m

2. Implement models and likelihood function, add models to mat-file using createAllModelsFile.m

3. Implement interface between model and data using link_ModelData()



### installFitting()
    Create folders in a model repository.

### initFitting()
    Important to run before anything else.

### ret = initDocu(uid, nosave)
    creates a new docu-file by calling a set_uid*uid* command as coded in SetParaFunc. This allows to set-up
    a new fitt without the help of the GUI.


## Docu struct
The Docu-struct is central to the Modelling Tool. It containts all relevant information. Here are the main fields:
#### uid
unique identifier for this docu struct/file
#### model
 struct; all info on the model
#### data
struct; the data and description
#### param_label
 string; identifier for bounds of prior
#### filename
string; filename of docu file
#### old_ver
 cell struct; older versions of this docu struct/file
#### best
 struct; results and parameters for best fit
#### descr
 struct; text documentation for parent fit, current fit and reason for the next fit
#### versPointers
struct; pointers to parents and children in the version tree
#### modTimes
 cell strings; time stamps for creation and saves
#### vers
struct; major and minor version of the fitting software the docu struct/file was safed with
#### UserDefined
 up to the user


## Util functions:

### [rtVersMajor, rtVersMinor] = getVersion()


### ret = load_docufile(uid)
ret = load_docufile(model_name, participant, param_label, uid)
   loads docufiles.


### ret = save_docufile(data)
    saves docu struct.

### uid_table = uid_lookuptable(folder)

### uid_table = uid_lookuptable()
    returns names of all docu-files in folder (Docus).

 
### ret = add_captionsave(docu, new_text)
    adds caption text to the figure field.

### ret = add_child(participant, model_name, uid, param_label, parent_simuname, parent_version)

### ret = edit_descr(file_identifier, type_of_descr, new_text)

### ret = exist_docufile(filename)

### out_filename = gen_docufilename(model_name, dataSelectorLabel, param_label, uid)

### modelLabels = load_modellabel(id)

### selector = load_selectors(id)

### ret = addDescrFuture(id, new_text)

### ret = createDocustruct()

### ret = addInit(uid, initValues)
