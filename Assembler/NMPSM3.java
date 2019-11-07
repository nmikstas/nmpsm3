package nmpsm3;

import java.io.RandomAccessFile;
import java.io.IOException;
import java.util.Vector;

//A simple class to store alias associations.
class AliasSet {
    AliasSet(String as, String rs) {
        aliasString = as;
        replacementString = rs;
    }
    public String aliasString;
    public String replacementString;
}

//A simple class to store address labels.
class Labels {
    Labels(String ln, int la, int lin) {
        labelName = ln;
        labelAddress = la;
        lineNumber = lin;
    }
    public String labelName;
    public int labelAddress;
    public int lineNumber;
}

//A simple class to store error events.
class Error{
    Error(String es, int el) {
        errorString = es;
        errorLine = el;
    }
    public String errorString;
    public int errorLine;
}

public class NMPSM3 {

    //Line number where error occurs.
    private int errorLine = 0;
    //Current address.
    private int currentAddress = 0;
    //Program size limit. Min. = 1, max = 65536, default = 512.
    private int sizeLimit = 512;
    //Input file.
    private RandomAccessFile read;
    //Output file.
    private RandomAccessFile write;
    //Output array. Size calculated later.
    private String[] output;
    //Input vector.
    private Vector<String> input = new Vector<String>();
    //Vector of aliases.
    private Vector<AliasSet> aliases = new Vector<AliasSet>();
    //Vector of addresses corresponding to each program line.
    private Vector<Integer> addresses = new Vector<Integer>();
    //Vector of labels.
    private Vector<Labels> labels = new Vector<Labels>();
    //Vector of error messages.
    private Vector<Error> error = new Vector<Error>();
    //Reserved words not to be used in labels.
    private String[] reserved = {"load", "stor", "jump", "jpnz", "jpz" , "jpnc",
                                 "jpc" , "call", "clnz", "clz" , "clnc", "clc" ,
                                 "ret" , "rtnz", "rtz" , "rtnc", "rtc" , "rtie",
                                 "rtid", "in"  , "out" , "and" , "or"  , "xor" ,
                                 "add" , "addc", "sub" , "subc", "test", "comp",
                                 "asl" , "rol" , "lsr" , "ror" , "setc", "clrc",
                                 "ein0", "ein1", "ein2", "ein3", "din0", "din1",
                                 "din2", "din3", "push", "pop"};
    //Invalid label characters.
    private String[] invalidChars = {"!" , "@" , "#" , "$" , "%" , "^" , "&" ,
                                     "*" , "(" , ")" , "+" , "=" , "`" , "~" ,
                                     "\\", "|" , "]" , "[" , "{" , "}" , ";" ,
                                     ":" , "\"", "\'", "-" , "<" , "," , ">" ,
                                     "." , "/" , "?"};
    //Arrays containing the different types of instructions.
    private String[] inst1 = {"ret" , "rtnz", "rtz" , "rtnc", "rtc" , "rtie",
                              "rtid", "setc", "clrc", "ein0", "ein1", "ein2",
                              "ein3", "din0", "din1", "din2", "din3"};
    private String[] inst2 = {"jump", "jpnz", "jpz" , "jpnc", "jpc" , "call",
                              "clnz", "clz" , "clnc", "clc" , "asl" , "rol" ,
                              "lsr" , "ror" , "push", "pop"};
    private String[] inst3 = {"load", "stor", "in"  , "out" , "and" , "or"  ,
                              "xor" , "add" , "addc", "sub" , "subc", "test",
                              "comp"};
    //Invalid instructions
    private String[] invalidInst =  {"stork", "jumpk", "jpnzk", "jpnzi",
                                     "jpzk" , "jpzi" , "jpnck", "jpnci",
                                     "jpck" , "jpci" , "callk", "clnzk",
                                     "clnzi", "clzk" , "clzi" , "clnck",
                                     "clnci", "clck" , "clci" , "ini"  ,
                                     "outi" , "andi" , "ori"  , "xori" ,
                                     "addi" , "addci", "subi" , "subci",
                                     "testi", "compi", "aslk" , "asli" ,
                                     "rolk" , "roli" , "lsrk" , "lsri" ,
                                     "rork" , "rori" , "pushk", "pushi",
                                     "popk" , "popi"};
    //Array of complete commands
    private String[] completeInst = {"loadk", "load" , "loadi", "stor" ,
                                     "stori", "jump" , "jumpi", "jpnz" ,
                                     "jpz"  , "jpnc" , "jpc"  , "call" ,
                                     "calli", "clnz" , "clz"  , "clnc" ,
                                     "clc"  , "ret"  , "rtnz" , "rtz"  ,
                                     "rtnc" , "rtc"  , "rtie" , "rtid" ,
                                     "ink"  , "in"   , "outk" , "out"  ,
                                     "andk" , "and"  , "ork"  , "or"   ,
                                     "xork" , "xor"  , "addk" , "add"  ,
                                     "addck", "addc" , "subk" , "sub"  ,
                                     "subck", "subc" , "testk", "test" ,
                                     "compk", "comp" , "asl"  , "rol"  ,
                                     "lsr"  , "ror"  , "setc" , "clrc" ,
                                     "ein0" , "ein1" , "ein2" , "ein3" ,
                                     "din0" , "din1" , "din2" , "din3" ,
                                     "push" , "pop"};
    //Opcodes for the above instructions.
    private String[] opcodes = {"01", "04", "07", "0A", "0D", "10", "13", "16",
                                "19", "1C", "20", "23", "26", "29", "2C", "30",
                                "33", "36", "39", "3C", "40", "43", "46", "49",
                                "4C", "50", "53", "56", "59", "5C", "60", "63",
                                "66", "69", "6C", "70", "73", "76", "79", "7C",
                                "80", "83", "86", "89", "8C", "90", "93", "96",
                                "99", "9C", "A0", "A3", "A6", "A9", "AC", "B0",
                                "B3", "B6", "B9", "BC", "C0", "C6"};

    NMPSM3(String[] arguments) {

        //Check for proper number of arguments.
        if (arguments.length < 1 || arguments.length > 2) {
            System.out.println("\nThe proper usage of the assembler is as follows:\n" +
                    "\njava -jar NMPSM3.jar [input.file] {[output.file]}\n\n" +
                    "A minimum of one argument is required which is the input assembly file.\n" +
                    "The output file name is optional.  If an output file name is not\n" +
                    "specified, the input file name with a .coe extension is created.");
            System.exit(1);
        }

        try {
            //Open input assembly file to read from.
            read = new RandomAccessFile(arguments[0], "r");                       
        }
        catch (IOException ioException) {
            System.err.println("Error opening file: " + ioException);
            System.exit(1);
        }

        try {
            //Fill input vector.
            while (read.getFilePointer() != read.length()) {
                input.add(read.readLine());
            }
        }
        catch (IOException ioException) {
            System.err.println("Error reading file: " + ioException);
            System.exit(1);
        }

////////////////////////Start processing input vector///////////////////////////
        //Remove all comments from input vector.
        CommentRemover();

        //Remove all blank lines from input vector.
        BlankLineRemover();

        //Replace all commas with spaces.
        CommaRemover();

        //Remove consecutive blank spaces from input vector.
        SpaceRemover();

        //Create alias vector.        
        AliasVector();        

        //Replace aliases in input vector.
        ReplaceAliases();

        //Set program size limit.
        ProgramSizer();

        //Fill address vector.
        FillAddressVector();
        
        //Verify the labels are properly formed and fill the label vector.
        LabelChecker();
       
        //Process the instructions.
        ProcessCode();

        //Fill output vector.
        FillOutput();

        //Print errors.
        PrintErrors();
        
        //Check vector.
        //VectorPrint();
        //Check addresses.
        //AddressPrint();

/////////////////////////End processing input vector////////////////////////////
        try {
            //Open output .coe file to write to.
            if(arguments.length == 2)
                write = new RandomAccessFile(arguments[1], "rw");
            else
                write = new RandomAccessFile(arguments[0].substring(0, arguments[0].indexOf('.')) + ".coe", "rw");
        }
        catch (IOException ioException) {
            System.err.println("Error opening file: " + ioException);
            System.exit(1);
        }

        //Write to output file.
        WriteOutput();        

        try {
            //Close read file
            if (read != null) {
                read.close();
            }
            //Close write file
            if (write != null) {
                write.close();
            }
        }
        catch (IOException ioException) {
            System.err.println("Error closing file: " + ioException);
            System.exit(1);
        }
        System.out.println("\nNMPSM3 .coe file created successfully.\n");
    }

///////////////////////////////Utility methods//////////////////////////////////
    void VectorPrint() {
        //Print input vector.  Used during development.
        System.out.println("\nInput Vector:");
        for(int i = 0; i < input.size(); i++) {
            System.out.println(input.elementAt(i));
        }
    }

    void AddressPrint() {
        //Print addresses vector.  Used during development.
        System.out.println("\nAddress Vector:");
        for(int i = 0; i < addresses.size(); i++) {
            System.out.println(addresses.elementAt(i));
        }
    }

    void CommentRemover() {
        //Trim all comments from input vector.
        for(int i = 0; i < input.size(); i++) {
            String s = input.elementAt(i);
            String[] tokenizedString = s.split(";");
            input.setElementAt(tokenizedString[0], i);
        }
    }

    void BlankLineRemover() {
        for(int i = 0; i < input.size(); i++) {
            String s = input.elementAt(i);
            s = s.replaceAll("\t", " ");
            s = s.replaceAll("\n", "");
            s = s.trim();
            input.setElementAt(s, i);
        }
    }

    void CommaRemover() {
        for(int i = 0; i < input.size(); i++) {
            String s = input.elementAt(i);
            s = s.replaceAll(",", " ");
            input.setElementAt(s, i);
        }
    }

    void SpaceRemover() {
        for(int i = 0; i < input.size(); i++) {
            String s = input.elementAt(i);
            String newString = "";
            String[] tokenizedString = s.split(" ");
            for(int j = 0; j < tokenizedString.length; j++) {
                if(tokenizedString[j].length() != 0)
                    newString = newString + tokenizedString[j] + " ";
            }
            newString = newString.trim();
            input.setElementAt(newString, i);
        }
    }

    void AliasVector() {
        for(int i = 0; i < input.size(); i++) {
            try {
                errorLine = i + 1;
                String s = input.elementAt(i);
                String[] tokenizedString = s.split(" ");
                if(tokenizedString[0].toLowerCase().equals(".alias")) {
                    if(tokenizedString.length != 3)
                        throw new Exception();
                    //Add alias to vector.
                    aliases.addElement(new AliasSet(tokenizedString[1], tokenizedString[2]));
                    //erase alias from input vector.
                    input.setElementAt("", i);
                }
            }
            catch (Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Invalid .ALIAS", errorLine));
            }
        }
    }

    void ReplaceAliases() {
        for(int i = 0; i < input.size(); i++) {
            String newString = "";
            String temp;
            String s = input.elementAt(i);
            String[] tokenizedString = s.split(" ");
            for(int j = 0; j < tokenizedString.length; j++) {
                for(int k = 0; k < aliases.size(); k++) {
                    //Check for alias inside parenthesis.
                    if(tokenizedString[j].startsWith("(") && tokenizedString[j].endsWith(")")) {
                        temp = tokenizedString[j].substring(1, tokenizedString[j].length() - 1);
                        if(aliases.elementAt(k).aliasString.equals(temp))
                            tokenizedString[j] = "(" + aliases.elementAt(k).replacementString + ")";
                    }
                    if(aliases.elementAt(k).aliasString.equals(tokenizedString[j]))
                        tokenizedString[j] = aliases.elementAt(k).replacementString;
                }
            }
            for(int j = 0; j < tokenizedString.length; j++) {
                newString = newString + tokenizedString[j] + " ";
            }
            newString = newString.trim();
            input.setElementAt(newString, i);
        }
    }

    void ProgramSizer() {
        boolean sizeFound = false;
        for(int i = 0; i < input.size(); i++) {
            errorLine = i + 1;
            String s = input.elementAt(i);
            String[] tokenizedString = s.split(" ");
            try {
                //Size directive already found.  Throw exception.
                if(tokenizedString[0].toLowerCase().equals(".size") && sizeFound == true)
                    throw new Exception();
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Multiple .SIZE directives", errorLine));
            }
            try {
                //Check if only one size argument.
                if(tokenizedString[0].toLowerCase().equals(".size") && tokenizedString.length != 2)
                    throw new Exception();
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Incorrect number of .SIZE arguments", errorLine));
            }
            try {
                //Attempt to convert size argument to an integer.
                if(tokenizedString[0].toLowerCase().equals(".size")) {
                    sizeLimit = NumberConverter(tokenizedString[1]);
                    sizeFound = true;
                    //Remove .size directive
                    input.setElementAt("", i);
                }
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Invalid .SIZE argument", errorLine));
            }
            try {
                //Check if size argument is within the proper range of 1 to 65536.
                if(sizeLimit < 1 || sizeLimit > 65536) {
                    sizeLimit = 65536;
                    input.setElementAt("", i);
                    throw new Exception();
                }
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error(".SIZE argument out of range", errorLine));
            }
        }
        //Instantiate and size output array.
        output = new String[sizeLimit];
        //Initialize array values to $000000000.
        for(int i = 0; i < output.length; i++) {
            output[i] = "000000000";
        }
    }

    int NumberConverter(String s) {
        int number = 0;
        //Radix of number
        int numberType = 0;
        //Check if hex number.
        if(s.charAt(0) == '$') {
            numberType = 16;
            s = s.substring(1);
        }
        //Check if binary number.
        else if(s.charAt(0) == '%') {
            numberType = 2;
            s = s.substring(1);
        }
        else
            numberType = 10;
        //Attempt to parse.  Exception will be caught by calling method.
        number = Integer.parseInt(s, numberType);
        return number;
    }

    void FillAddressVector() {
        for(int i = 0; i < input.size(); i++) {
            errorLine = i + 1;
            String s = input.elementAt(i);
            String[] tokenizedString = s.split(" ");
            //Empty element.
            if(s.length() == 0) {
                addresses.addElement(currentAddress);
            }
            //Check to see if valid .ORG directive is present.
            else if(tokenizedString[0].toLowerCase().equals(".org")) {
                try {
                    if(tokenizedString.length != 2)
                        throw new Exception();
                    currentAddress = NumberConverter(tokenizedString[1]);
                    addresses.addElement(currentAddress);
                    //Erase .ORG directive
                    input.setElementAt("", i);
                }
                catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Incorrect number of .ORG arguments", errorLine));
                }
            }
            //Check to see if label is present.
            else if(tokenizedString[0].contains(":")) {
                //Throw exception if more than 1 colon
                try {
                    int charCounter = 0;
                    for(int j = 0; j < s.length(); j++)
                        if(s.charAt(j) == ':')
                            charCounter++;
                    if(charCounter > 1){
                        throw new Exception();
                    }
                }
                catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Multiple labels", errorLine));
                }
                //Check if label only line.
                if(tokenizedString.length == 1 && tokenizedString[0].charAt(tokenizedString[0].length() - 1) == ':')
                    addresses.addElement(currentAddress);
                //Else must be a label plus an instruction.
                else {
                    //Add space between label and instruction.
                    String[] labelTokenizer = s.split(":");
                    labelTokenizer[0] = labelTokenizer[0].trim();
                    labelTokenizer[1] = labelTokenizer[1].trim();
                    input.setElementAt(labelTokenizer[0] + ": " + labelTokenizer[1], i);
                    addresses.addElement(currentAddress);
                    currentAddress++;
                }
            }
            //Only possibility left is an instruction only.
            else {
                addresses.addElement(currentAddress);
                currentAddress++;
            }
            //Throw exception if spaces in label.
            try {
                for(int k = 1; k < tokenizedString.length; k++)
                    if(tokenizedString[k].contains(":"))
                        throw new Exception();
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Invalid label", errorLine));
            }
        }
    }

    void LabelChecker() {
        for(int i = 0; i < input.size(); i++) {
            errorLine = i + 1;
            String newString = "";
            String s = input.elementAt(i);
            String[] tokenizedString = s.split(" ");
            //Fill labels vector.
            if(tokenizedString[0].length() > 0 && tokenizedString[0].charAt(tokenizedString[0].length() - 1) == ':') {
                labels.addElement(new Labels(tokenizedString[0], addresses.elementAt(i), errorLine));
                //Remove label from input vector.
                if(tokenizedString.length > 1) {
                    for(int j = 1; j < tokenizedString.length; j++)
                        newString = newString + tokenizedString[j] + " ";
                    newString.trim();
                    input.setElementAt(newString, i);
                }
                else
                    input.setElementAt("", i);
            }
        }
        //Remove colons from labels and throw exceptions on empty labels.
        for(int i = 0; i < labels.size(); i++) {
            try {
                errorLine = labels.elementAt(i).lineNumber;
                labels.elementAt(i).labelName = labels.elementAt(i).labelName.split(":")[0];
            }
             catch(Exception exception) {
                 if(!CheckErrorLine(errorLine))
                     error.addElement(new Error("Invalid label", errorLine));
             }
        }
        //Check for reserved words.
        for(int i = 0; i < labels.size(); i++) {
            try {
                errorLine = labels.elementAt(i).lineNumber;
                for(int j = 0; j < reserved.length; j++)
                    if(labels.elementAt(i).labelName.toLowerCase().equals(reserved[j].toLowerCase()))
                        throw new Exception();
            }        
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Reserved word used in label", errorLine));
            }
        }
        //Check for invalid characters.
        for(int i = 0; i < labels.size(); i++) {
            try {
                errorLine = labels.elementAt(i).lineNumber;
                for(int j = 0; j < invalidChars.length; j++)
                    if(labels.elementAt(i).labelName.contains(invalidChars[j]))
                        throw new Exception();
            }        
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Invalid character in label", errorLine));
            }
        }
        //Check to make sure label does not start with a number.
        for(int i = 0; i < labels.size(); i++) {
            try {
                errorLine = labels.elementAt(i).lineNumber;
                if(Character.isDigit(labels.elementAt(i).labelName.charAt(0)))
                    throw new Exception();
            }        
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Label starting with a number", errorLine));
            }
        }
        //Check for duplicate labels.
        for(int i = 0; i < labels.size() - 1; i++) {
            try {
                for(int j = i + 1; j < labels.size(); j++) {
                    errorLine = labels.elementAt(j).lineNumber;
                    if(labels.elementAt(i).labelName.equals(labels.elementAt(j).labelName))
                        throw new Exception();
                }
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Duplicate label", errorLine));
            //System.err.println("Duplicate label. Line " + errorLine);
            //System.exit(1);
            }
        }
        //Check for labels already being used as aliases.
        for(int i = 0; i < labels.size(); i++) {
            try{
                for(int j = 0; j < aliases.size(); j++) {
                    errorLine = labels.elementAt(i).lineNumber;
                    if(labels.elementAt(i).labelName.equals(aliases.elementAt(j).aliasString))
                        throw new Exception();
                }
            }
            catch(Exception exception) {
                if(!CheckErrorLine(errorLine))
                    error.addElement(new Error("Label already used as alias", errorLine));
            }            
        }   
    }

    void ProcessCode() {
        for(int i = 0; i < input.size(); i++) {
            int instType, argument1, argument2;
            String argHex1, argHex2;
            errorLine = i + 1;
            String s = input.elementAt(i);
            if(s.length() != 0) {
                String[] tokenizedString = s.split(" ");
                instType = GetInstType(tokenizedString[0]);
                //Check to see if instruction is a valid instruction.
                try {
                    if(instType == -1)
                        throw new Exception();
                }
                catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Undefined instruction", errorLine));
                }
                try {
                    if(tokenizedString.length != instType)
                        throw new Exception();
                }
                catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Incorrect number of arguments", errorLine));
                }
                //Check if instruction is a constant instruction and change it accordingly.
                if(instType == 3 && tokenizedString[2].startsWith("#")) {
                    tokenizedString[0] = tokenizedString[0] + "k";
                    tokenizedString[2] = tokenizedString[2].substring(1, tokenizedString[2].length());
                    //Special case for LOAD rx, #k for loading labels.
                    if(tokenizedString[0].toLowerCase().equals("loadk"))
                        for(int j = 0; j < labels.size(); j++)
                            if(tokenizedString[2].equals(labels.elementAt(j).labelName))
                                tokenizedString[2] = "" + labels.elementAt(j).labelAddress;
                    input.setElementAt((tokenizedString[0] + " " + tokenizedString[1] + " " + tokenizedString[2]), i);
                }
                if(instType == 2 && tokenizedString[1].startsWith("#")) {
                    tokenizedString[0] = tokenizedString[0] + "k";
                    tokenizedString[1] = tokenizedString[1].substring(1, tokenizedString[1].length());
                    input.setElementAt((tokenizedString[0] + " " + tokenizedString[1]), i);
                }
                //Check if instruction is an indirect instruction and change it accordingly.
                if(instType == 3 && tokenizedString[2].startsWith("(") && tokenizedString[2].endsWith(")")) {
                    tokenizedString[0] = tokenizedString[0] + "i";
                    tokenizedString[2] = tokenizedString[2].substring(1, tokenizedString[2].length() - 1);
                    input.setElementAt((tokenizedString[0] + " " + tokenizedString[1] + " " + tokenizedString[2]), i);
                }
                if(instType == 2 && tokenizedString[1].startsWith("(") && tokenizedString[1].endsWith(")")) {
                    tokenizedString[0] = tokenizedString[0] + "i";
                    tokenizedString[1] = tokenizedString[1].substring(1, tokenizedString[1].length() - 1);
                    input.setElementAt((tokenizedString[0] + " " + tokenizedString[1]), i);
                }
                //Check to see if illegal addressing mode for this instruction.
                try {
                    for(int j = 0; j < invalidInst.length; j++)
                        if(tokenizedString[0].toLowerCase().equals(invalidInst[j]))
                            throw new Exception();
                }
                 catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Invalid addressing mode", errorLine));
                }
                //Substitute labels for addresses.
                if(tokenizedString[0].toLowerCase().equals("jump") || tokenizedString[0].toLowerCase().equals("jpnz") ||
                   tokenizedString[0].toLowerCase().equals("jpz")  || tokenizedString[0].toLowerCase().equals("jpnc") ||
                   tokenizedString[0].toLowerCase().equals("jpc")  || tokenizedString[0].toLowerCase().equals("call") ||
                   tokenizedString[0].toLowerCase().equals("clnz") || tokenizedString[0].toLowerCase().equals("clz")  ||
                   tokenizedString[0].toLowerCase().equals("clnc") || tokenizedString[0].toLowerCase().equals("clc"))
                    for(int j = 0; j < labels.size(); j++)
                        if(tokenizedString[1].equals(labels.elementAt(j).labelName))
                            input.setElementAt((tokenizedString[0] + " " + labels.elementAt(j).labelAddress), i);
                //Validate parameters and replace instructions with opcodes.
                try {
                    //Single argument instruction.
                    if(instType == 1)
                        for(int j = 0; j < completeInst.length; j++)
                            if(tokenizedString[0].toLowerCase().equals(completeInst[j]))
                                input.setElementAt((opcodes[j] + "0000000"), i);
                    //Two argument, indirect instruction or direct instruction.
                    if(instType == 2 && (tokenizedString[0].endsWith("i") || tokenizedString[0].toLowerCase().equals("asl")  ||
                           tokenizedString[0].toLowerCase().equals("rol") || tokenizedString[0].toLowerCase().equals("lsr")  ||
                           tokenizedString[0].toLowerCase().equals("ror") || tokenizedString[0].toLowerCase().equals("push") ||
                           tokenizedString[0].toLowerCase().equals("pop"))) {
                        argument1 = NumberConverter(tokenizedString[1]);
                        try {
                            if(argument1 >= 0x400)
                                throw new Exception();
                        }
                        catch (Exception excepion) {
                            if(!CheckErrorLine(errorLine))
                                error.addElement(new Error("Register address out of range", errorLine));
                        }
                        //convert integer to hex string.
                        argHex1 = Integer.toHexString(argument1);
                        //Add leading zeroes, if necessary.
                        if(argHex1.length() == 1)
                            argHex1 = "00" + argHex1;
                        if(argHex1.length() == 2)
                            argHex1 = "0" + argHex1;
                        //Replace command in input vector with opcode.
                        for(int j = 0; j < completeInst.length; j++)
                            if(tokenizedString[0].toLowerCase().equals(completeInst[j]))
                                input.setElementAt((opcodes[j] + argHex1.toUpperCase() + "0000"), i);
                    }
                    //Two argument, address instruction.
                    if(tokenizedString[0].toLowerCase().equals("jump") || tokenizedString[0].toLowerCase().equals("jpnz") ||
                       tokenizedString[0].toLowerCase().equals("jpz")  || tokenizedString[0].toLowerCase().equals("jpnc") ||
                       tokenizedString[0].toLowerCase().equals("jpc")  || tokenizedString[0].toLowerCase().equals("call") ||
                       tokenizedString[0].toLowerCase().equals("clnz") || tokenizedString[0].toLowerCase().equals("clz")  ||
                       tokenizedString[0].toLowerCase().equals("clnc") || tokenizedString[0].toLowerCase().equals("clc")) {
                        //Retokenize line string.
                        s = input.elementAt(i);
                        tokenizedString = s.split(" ");
                        argument1 = NumberConverter(tokenizedString[1]);
                        try {
                            if(argument1 >= 0x10000)
                                throw new Exception();
                        }
                        catch (Exception excepion) {
                            if(!CheckErrorLine(errorLine))
                                error.addElement(new Error("ROM address out of range", errorLine));                            
                        }
                        //Jump out of program size limit.
                        try {
                            if(argument1 > sizeLimit)
                                throw new Exception();
                        }
                        catch (Exception excepion) {
                            if(!CheckErrorLine(errorLine))
                                error.addElement(new Error("JUMP/CALL address greater than program size limit", errorLine));
                        }
                        //convert integer to hex string.
                        argHex1 = Integer.toHexString(argument1);
                        //Add leading zeroes, if necessary.
                        if(argHex1.length() == 1)
                            argHex1 = "000" + argHex1;
                        if(argHex1.length() == 2)
                            argHex1 = "00" + argHex1;
                        if(argHex1.length() == 3)
                            argHex1 = "0" + argHex1;
                        //Replace command in input vector with opcode.
                        for(int j = 0; j < completeInst.length; j++)
                            if(tokenizedString[0].toLowerCase().equals(completeInst[j]))
                                input.setElementAt((opcodes[j] + "000" + argHex1.toUpperCase()), i);
                    }
                    //Three argument, indirect instruction and immediate instruction.
                    if(instType == 3) {
                        //Identify instruction.
                        for(int j = 0; j < completeInst.length; j++) {
                            if(tokenizedString[0].toLowerCase().equals(completeInst[j])) {
                                //First argument same type regardless of instruction type.
                                argument1 = NumberConverter(tokenizedString[1]);
                                try {
                                    if(argument1 >= 0x400)
                                        throw new Exception();
                                }
                                catch (Exception excepion) {
                                    if(!CheckErrorLine(errorLine))
                                        error.addElement(new Error("Register address out of range", errorLine));                                    
                                }
                                //Add leading zeroes, if necessary.
                                argHex1 = Integer.toHexString(argument1);
                                if(argHex1.length() == 1)
                                    argHex1 = "00" + argHex1;
                                if(argHex1.length() == 2)
                                    argHex1 = "0" + argHex1;
                                //Indirect instruction.
                                if(tokenizedString[0].endsWith("i")) {
                                    argument2 = NumberConverter(tokenizedString[2]);
                                    try {
                                        if(argument2 >= 0x400)
                                        throw new Exception();
                                    }
                                    catch (Exception excepion) {
                                        if(!CheckErrorLine(errorLine))
                                            error.addElement(new Error("Register address out of range", errorLine));                                       
                                    }
                                    //Add leading zeroes, if necessary.
                                    argHex2 = Integer.toHexString(argument2);
                                    if(argHex2.length() == 1)
                                        argHex2 = "000" + argHex2;
                                    if(argHex2.length() == 2)
                                        argHex2 = "00" + argHex2;
                                    if(argHex2.length() == 3)
                                        argHex2 = "0" + argHex2;
                                }
                                //Immediate instruction.
                                else if(tokenizedString[0].endsWith("k")){
                                    argument2 = NumberConverter(tokenizedString[2]);
                                    try {
                                        if(argument2 >= 0x10000)
                                        throw new Exception();
                                    }
                                    catch (Exception excepion) {
                                        if(!CheckErrorLine(errorLine))
                                            error.addElement(new Error("Constant value out of range", errorLine));                                      
                                    }
                                    //Add leading zeroes, if necessary.
                                    argHex2 = Integer.toHexString(argument2);
                                    if(argHex2.length() == 1)
                                        argHex2 = "000" + argHex2;
                                    if(argHex2.length() == 2)
                                        argHex2 = "00" + argHex2;
                                    if(argHex2.length() == 3)
                                        argHex2 = "0" + argHex2;
                                }
                                //Direct instruction.
                                else {
                                    argument2 = NumberConverter(tokenizedString[2]);
                                    try {
                                        if(argument2 >= 0x400)
                                        throw new Exception();
                                    }
                                    catch (Exception excepion) {
                                        if(!CheckErrorLine(errorLine))
                                            error.addElement(new Error("Register address out of range", errorLine));                                       
                                    }
                                    //Add leading zeroes, if necessary.
                                    argHex2 = Integer.toHexString(argument2);
                                    if(argHex2.length() == 1)
                                        argHex2 = "000" + argHex2;
                                    if(argHex2.length() == 2)
                                        argHex2 = "00" + argHex2;
                                    if(argHex2.length() == 3)
                                        argHex2 = "0" + argHex2;
                                }
                                //Replace command in input vector with opcode.
                                input.setElementAt((opcodes[j] + argHex1.toUpperCase() + argHex2.toUpperCase()), i);
                            }
                        }
                    }
                }
                catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Invalid parameter", errorLine));
                }
            }
        }
    }

    int GetInstType(String s) {
        //Search through the instructions to make sure they are valid and
        //determine how many parameters each instruction should have.
        for(int i = 0; i < inst1.length; i++) {
            if(s.toLowerCase().equals(inst1[i]))
                return 1;
        }
        for(int i = 0; i < inst2.length; i++) {
            if(s.toLowerCase().equals(inst2[i]))
                return 2;
        }
        for(int i = 0; i < inst3.length; i++) {
            if(s.toLowerCase().equals(inst3[i]))
                return 3;
        }
        return -1;
    }

    void FillOutput() {
        for(int i = 0; i < input.size(); i++) {
            errorLine = i + 1;
            //Process element only if it contains data.
            if(input.elementAt(i).length() != 0) {
                //Make sure address is within program size limit.
                try {
                    if(addresses.elementAt(i) >= sizeLimit)
                        throw new Exception();
                }
                catch(Exception exception) {                    
                    error.addElement(new Error("Instruction address exceeds program size limit", errorLine));                   
                }
                //Check to see if instruction address is not already occupied.
                try {
                    if(!output[addresses.elementAt(i)].equals("000000000"))
                        throw new Exception();
                }
                catch(Exception exception) {
                    if(!CheckErrorLine(errorLine))
                        error.addElement(new Error("Instruction address already occupied", errorLine));
                }
                //Write opcode to output vector.
                if(error.isEmpty())
                    output[addresses.elementAt(i)] = input.elementAt(i);
            }
        }
    }

    void WriteOutput() {
        String memInit = "memory_initialization_radix=16;";
        String initVector = "memory_initialization_vector=";
        try {
            write.setLength(0); //Erase any previous contents.
            write.writeBytes(memInit); //Write init strings.
            write.writeByte(0x0D); //Notepad new lines.
            write.writeByte(0x0A);
            write.writeBytes(initVector);
            //Write opcodes.
            for(int i = 0; i < output.length - 1; i++) {
                //New line after every eight opcodes.
                if(i % 8 == 0) {
                    write.writeByte(0x0D); //Notepad new lines.
                    write.writeByte(0x0A);
                }
                write.writeBytes(output[i] + ", ");
            }
            //Write last instruction in file.
            if((output.length % 8 == 1) && (output.length > 1)) {
                write.writeByte(0x0D); //Notepad new lines.
                write.writeByte(0x0A);
            }
            write.writeBytes(output[output.length - 1] + ";");
        }
        catch (IOException ioException) {
            System.err.println("Error writing to .coe file: " + ioException);
            System.exit(1);
        }
    }

    void PrintErrors() {
        if(error.isEmpty()) {
            System.out.println("\nNo errors detected.");
            return;
        }
        System.out.println("\nErrors:");
        for(int i = 0; i < error.size(); i++) {
            System.out.println(error.elementAt(i).errorString + " " + error.elementAt(i).errorLine);
        }
        System.out.println("Total errors: " + error.size());
        System.exit(1);
    }

    boolean CheckErrorLine(int errorLine) {
        for(int i = 0; i < error.size(); i++)
            if(error.elementAt(i).errorLine == errorLine)
                return true;
        return false;
    }

/////////////////////////////////Main method////////////////////////////////////
    public static void main(String[] args) {
       NMPSM3 nmpsm3 = new NMPSM3(args);
    }
}
