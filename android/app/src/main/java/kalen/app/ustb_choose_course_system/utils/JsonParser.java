package kalen.app.ustb_choose_course_system.utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.util.ArrayList;
import java.util.List;

import kalen.app.ustb_choose_course_system.model.ClassBean;

/**
 * Created by kalen on 15-8-11.
 */
public class JsonParser {
    JSONObject jsonObject;

    public JsonParser(String jsonStr)  throws JSONException {
        System.out.println(jsonStr);
        JSONTokener jsonTokener = new JSONTokener(jsonStr);
        //得到JsonObject
        jsonObject = (JSONObject) jsonTokener.nextValue();
    }

    /**
     *
     * @return
     */
    public List<ClassBean> getSelectedCourses() throws JSONException {

        return getCourses("selectedCourses");
    }

    /**
     *
     * @return
     */
    public List<ClassBean> getAlternativeCourses() throws JSONException {

        return getCourses("alternativeCourses");
    }

    /**
     * 已xiu公选课
     * @return
     * @throws JSONException
     */
    public List<ClassBean> getLearnedPublicCourses() throws JSONException{
        List<ClassBean> classes = new ArrayList<>();
        JSONArray array = jsonObject.getJSONArray("learnedPublicCourses");
        for (int i = 0; i < array.length(); i++) {
            JSONObject item = array.getJSONObject(i);
            String className = item.getString("DYKCM");
            String teacher = item.getString("LRR");
            String credit = item.getString("XF");
            String score = item.getString("GPACJ");
            classes.add(new ClassBean(className,
                    teacher,credit, score));

        }
        return classes;

    }

    /**
     *
     * @return
     * @throws JSONException
     */
    public String getSemester() throws JSONException{
        JSONArray array = jsonObject.getJSONArray("selectedCourses");
        return array.getJSONObject(0).getString("XNXQ");
    }


    /**
     *
     * @param type
     * @return
     */
    private List<ClassBean> getCourses(String type) throws JSONException {
        List<ClassBean> classes = new ArrayList<>();
        JSONArray array = jsonObject.getJSONArray(type);
        for (int i = 0; i < array.length(); i++) {
            JSONObject item = array.getJSONObject(i);
            String id = item.getInt("ID") + "";
            String className = item.getString("DYKCM");
            String teacher = "";
            try {
                teacher = item.getJSONArray("JSM").getJSONObject(0)
                        .getString("JSM");
            }catch (Exception e) {//index out of array size exeption
                teacher = "未知老师";
            }
            String credit = item.getString("XF");
            String time_and_position = item.getString("SKSJDDSTR");
            classes.add(new ClassBean(id, className,
                    teacher, time_and_position ,credit));

        }
        return classes;
    }

    /**
     *
     * @return
     * @throws JSONException
     */
    public List<ClassBean> getClassTableItems() throws JSONException{
        List<ClassBean> classes = new ArrayList<>();
        JSONArray array = jsonObject.getJSONArray("selectedCourses");
        for (int i = 0; i < array.length(); i++) {
            JSONObject item = array.getJSONObject(i);
            String className = item.getString("DYKCM");
            String teacher = "";
            try {
                teacher = item.getJSONArray("JSM").getJSONObject(0)
                        .getString("JSM");
            }catch (Exception e) {//index out of array size exeption
                teacher = "未知老师";
            }
            String time_and_position = item.getString("SKSJDDSTR");
            if (time_and_position.trim().equals("")){
                classes.add(new ClassBean(className, teacher, -1 , "", ""));
            }else{
                classes.addAll(parseClassTable(time_and_position, className, teacher));
            }

            JSONArray array2 = item.getJSONArray("PTK");
            for (int j = 0; j < array2.length(); j++){
                JSONObject item2 = array2.getJSONObject(j);
                String className2 = item2.getString("DYKCM");
                String teacher2;
                try {
                    teacher2 = item2.getJSONArray("JSM").getJSONObject(0)
                            .getString("JSM");
                }catch (Exception e) {//index out of array size exeption
                    teacher2 = "未知老师";
                }
                String time_and_position2 = item2.getString("SKSJDDSTR");
                if (time_and_position.trim().isEmpty()){
                    classes.add(new ClassBean(className2, teacher2, -1 , "", ""));
                }else{
                    classes.addAll(parseClassTable(time_and_position2,
                            className2, teacher2));
                }
            }
        }
        return classes;


    }

    /**
     * 提取课表信息
     * @param time_and_position
     * @param className
     * @param teacher
     * @return
     */
    private List<ClassBean> parseClassTable(String time_and_position,
                                            String className,String teacher){

        List<ClassBean> classes = new ArrayList<>();

        if(time_and_position.trim().split(" ").length == 1){
            classes.add(new ClassBean(className, teacher, -1, "", ""));
            return classes;
        }

        String[] datas = time_and_position.trim().split(" ");
        for(int i = 0; i < datas.length; i += 2){
            String position = datas[i + 1].split("\\)")[0];
            int weekTime = datas[i].split(",")[0].charAt(2) - 48;
            int whichNum = datas[i].split(",")[1] .charAt(1) - 48;
            int where = (weekTime - 1) * 6 + whichNum - 1;
            String time = datas[i].substring(8, datas[i].length());
            classes.add(new ClassBean(className, teacher, where, time, position));
        }
        return classes;
    }

}
