function game(students) {

    used_students = []
    for(var i =0; i < students.length; i++) {
        other_names = []
        correct = false
        current_student = students[Math.floor(Math.random() * students.length)]
        while(used_students.include(current_student)){
            current_student = students[Math.floor(Math.random() * students.length)]
        }
        while(other_names.length <= 3) {
            other_names << students.name[Math.floor(Math.random() * students.length)]
            if(other_names.include(current_student)){
                remove(other_names, current_student.name)
            }
        }
        document.getElementById("nameArea").innerHTML = `<img src="${current_student.image}">`
        other_names << current_student.name
        for(var i = 0; i < 5; i++){
            name = []
            name << other_names[Math.floor(Math.random() * other_names.length)]
            remove(other_names, name)
            document.getElementById("nameArea").innerHTML = `<div class="name"> ${name} </div>`
        }
        while(correct == false){
          // If the teacher picked right
            if(pickedName === current_student.name){
                correct = true

            } else{
                current_student = students[Math.floor(Math.random() * students.length)]
            }
        }
        used_students << current_student
    }

}

function remove(arr, value){

    return arr.filter(function(ele){
        return ele != value
    })

}