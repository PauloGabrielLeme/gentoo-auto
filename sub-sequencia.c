#include <stdio.h>
#include <string.h>

void inicializa(int n, int m,int tabela[n][m]);

int main(){
    char txt1 = 'adcbe';
    char txt2 = 'ace'; 
    int n = 5;
    int m = 3;


    int tabela[n+1][m+1];
    inicializa(m,m,tabela);

    

    for(int i=0;i<=n;i++){
        for(int j=0;j<=m;j++){
            if(txt1[i-1] == txt2[j-1] && i>=1 || j>=1){
                tabela[i][j] = tabela[i-1][j-1] + 1;
            }
        }
    }



    return 0;
}

void inicializa(int n, int m, int tabela[n][m]) {
    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= m; j++) {
            tabela[i][j] = 0;
        }
    }
}
