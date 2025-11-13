#include <iostream>
#include <utility>
#include <vector>
#include <algorithm>
#include <chrono>

using namespace std;

vector<pair<int, int>> move_knight(const vector<pair<int, int>>& pm, const int n) {
  if (n < 1) return pm;

  vector<pair<int,int>> temp;
  vector<pair<int,int>> moves = {
        { 2,  1}, { 2, -1},
        {-2,  1}, {-2, -1},
        { 1,  2}, { 1, -2},
        {-1,  2}, {-1, -2}
  };

  for (auto [x, y] : pm) {
    for (auto [dx, dy] : moves) {
      int nx = x + dx;
      int ny = y + dy;
      if (nx >= 1 && nx <= 8 && ny >= 1 && ny <= 8) temp.push_back({nx, ny});
    }
  }
  temp.insert(temp.end(), pm.begin(), pm.end());
  sort(temp.begin(), temp.end());
  auto unique_pos = unique(temp.begin(), temp.end());
  temp.erase(unique_pos, temp.end());
  return move_knight(temp, n-1);

}

int main() {
  int a, b, n;
  cout << "row col n: "; 
  cin >> a >> b >> n;

  auto start = chrono::high_resolution_clock::now();

  vector<pair<int, int>> tiles;
  tiles.push_back(make_pair(a, b));
  vector<pair<int, int>> pm = move_knight(tiles, n);
  
  bool first = true;
  for (auto [x, y] : pm) {
    if (!first) {
      cout << ", ";
    }
    cout << "(" << x << ", " << y << ")";
    first = false;
  }
  cout << endl;

  auto end = chrono::high_resolution_clock::now();
  chrono::duration<double> elapsed = end - start;
  cout << "Runtime: " << elapsed.count() << " seconds" << endl;

  return 0;
}
