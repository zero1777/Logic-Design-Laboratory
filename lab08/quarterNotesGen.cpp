#include <iostream>
#include <string>

using namespace std;

int main() {
    int num, cnt, par;
    string str, arr[1000];
    string c;

    cin >> par >> c;
    cnt = 0;

    while (1) {
        cin >> num >> str;
        if (num == 0)
            break;
        if (64 % num == 0)
            num = 64 / num;
        if (cnt > 0 && str == arr[cnt-1]) {
            arr[cnt++] = "sil";
            for (int i = 0; i < num-1; i++) {
                arr[cnt++] = str;
            }
        }
        else {
            for (int i = 0; i < num; i++) {
                arr[cnt++] = str;
            }
        }
    }

    if (c == "R") {
        for (int i = 0; i < cnt; i++) {
            if (i%2 == 0)
                cout << "15'd" << i+par << ": toneR = `" << arr[i] << ";"
                << "     ";
            else
                cout << "15'd" << i+par << ": toneR = `" << arr[i] << ";"
                << endl;
        }
    }
    else {
        for (int i = 0; i < cnt; i++) {
            if (i%2 == 0)
                cout << "15'd" << i+par << ": toneL = `" << arr[i] << ";"
                << "     ";
            else
                cout << "15'd" << i+par << ": toneL = `" << arr[i] << ";"
                << endl;
        }
    }
    
    return 0;
}