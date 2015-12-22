package kalen.app.ustb_choose_course_system.model;

/**
 * Created by kalen on 15-12-22.
 */
public class ExamInfo {
    private String ClassName;
    private String ExamTime;
    private String ExamLocation;

    public ExamInfo(String className, String examTime, String examLocation) {
        ClassName = className;
        ExamTime = examTime;
        ExamLocation = examLocation;
    }

    public String getClassName() {
        return ClassName;
    }

    public void setClassName(String className) {
        ClassName = className;
    }

    public String getExamTime() {
        return ExamTime;
    }

    public void setExamTime(String examTime) {
        ExamTime = examTime;
    }

    public String getExamLocation() {
        return ExamLocation;
    }

    public void setExamLocation(String examLocation) {
        ExamLocation = examLocation;
    }
}
